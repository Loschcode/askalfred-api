ActiveAdmin.register Ticket do
  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :identity
    column :title
    column :status
    column :subject
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :status, as: :select, collection: [:opened, :processing, :completed, :canceled]
  filter :title
  filter :created_at
  filter :updated_at

  permit_params :identity_id,
                :title,
                :status,
                :created_at,
                :updated_at

  action_item :end_request_successfully, only: :show, method: :get do
    link_to 'End request successfully (Email)', end_request_successfully_admin_ticket_path(ticket)
  end
  member_action :end_request_successfully, method: :get do
    ticket = Ticket.find(params[:id])
    ticket.update status: 'completed'
    IdentityMailer.with(identity: ticket.identity).request_completed(ticket).deliver_later

    redirect_to action: :show
  end

  action_item :cancel_request, only: :show, method: :get do
    link_to 'Cancel request (Email)', cancel_request_admin_ticket_path(ticket)
  end
  member_action :cancel_request, method: :get do
    ticket = Ticket.find(params[:id])
    ticket.update status: 'canceled'
    IdentityMailer.with(identity: ticket.identity).request_canceled(ticket).deliver_later
    redirect_to action: :show
  end

  action_item :request_in_progress, only: :show, method: :get do
    link_to 'Request in progress', request_in_progress_admin_ticket_path(ticket)
  end
  member_action :request_in_progress, method: :get do
    ticket = Ticket.find(params[:id])
    ticket.update status: 'processing'
    redirect_to action: :show
  end

  action_item :need_more_details, only: :show, method: :get do
    link_to 'I need more details (Email)', need_more_details_admin_ticket_path(ticket)
  end
  member_action :need_more_details, method: :get do
    ticket = Ticket.find(params[:id])
    IdentityMailer.with(identity: ticket.identity).alfred_needs_answers(ticket).deliver_later
    redirect_to action: :show
  end

  show title: :title do
    attributes_table do
      row :identity
      row :name do |event| event.identity.first_name end
      row :status
      row :title
      row :subject
      row :created_at
      row :updated_at
    end

    panel 'Events' do
      table_for ticket.events.order(created_at: :asc) do
        column :id do |event|
          a link_to(event.id, admin_event_path(event))
        end
        column :identity do |event|
          text_node event.identity.first_name
        end
        column :eventable_type
        column :data do |event|
          text_node event.eventable.body if event.eventable_type == 'EventMessage'
          a event.eventable.file_path if event.eventable_type == 'EventFile'
        end
        column :seen_at
        column :created_at
      end
    end

    panel 'Send message' do
      active_admin_form_for EventMessage.new, url: { action: :send_message } do |f|
        f.inputs do
          f.input :body, as: :text
        end
        f.actions do
          f.action :submit, label: 'Create message'
        end
      end
    end

    panel 'Send file' do
      active_admin_form_for EventFile.new, url: { action: :send_file } do |f|
        f.inputs do
          f.input :file, as: :file
        end
        f.actions do
          f.action :submit, label: 'Upload file'
        end
      end
    end

    panel 'Credits' do
      table_for ticket.credits.order(created_at: :asc) do
        column :id do |credit|
          a link_to(credit.id, admin_credit_path(credit))
        end
        column :identity do |credit|
          text_node credit.identity.first_name
        end
        column :stripe_charge_id
        column :time
        column :origin
        column :created_at
      end
    end

    panel 'Consume time' do
      active_admin_form_for Credit.new, url: { action: :consume_time } do |f|
        f.inputs do
          text_node 'This will be added to the list of credits as a negative one. Please refer to the total time you consumed in seconds.'
          f.input :time
        end
        f.actions do
          f.action :submit, label: 'Confirm time'
        end
      end
    end
  end

  member_action :consume_time, method: :post do
    ticket = Ticket.find(params[:id])
    time = params[:credit][:time].to_i

    Credit.create!(
      identity: ticket.identity,
      ticket: ticket,
      time: time * -1,
      origin: 'time_consumed_on_ticket'
    )

    RefreshService.new(ticket.identity).credits

    redirect_to action: :show
  end

  member_action :send_message, method: :post do
    identity = Identity.where(role: 'admin').take
    ticket = Ticket.find(params[:id])
    body = params[:event_message][:body]

    SendMessageService.new(
      identity: identity,
      ticket: ticket,
      body: body
    ).perform

    # if it's the first message
    # we should tell the guy via  email
    # this logic is obsolete now
    # if ticket.events.where(identity: identity).count == 1

    redirect_to action: :show
  end

  member_action :send_file, method: :post do
    identity = Identity.where(role: 'admin').take
    ticket = Ticket.find(params[:id])
    file = params[:event_file][:file]

    SendFileService.new(
      identity: identity,
      ticket: ticket,
      file: file
    ).perform

    redirect_to action: :show
  end

  form title: :title do |f|
    inputs 'Details' do
      input :identity_id, as: :select, collection: Identity.all.map { |identity| ["#{identity.first_name} #{identity.last_name}", identity.id]}
      input :title
      input :status, as: :select, collection: [:opened, :processing, :completed, :canceled]
      input :created_at
      input :updated_at
    end
    actions
  end

  controller do
    def update
      super
      # we dispatch it to the subscriptions as well
      RefreshService.new(resource.identity).tap do |refresh|
        refresh.ticket(resource)
        refresh.tickets_list
      end
    end
  end
end
