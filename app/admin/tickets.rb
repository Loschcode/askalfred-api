ActiveAdmin.register Ticket do
  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :identity
    column :title
    column :status
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

  show title: :title do
    attributes_table do
      row :title
      row :status
      row :title
      row :created_at
      row :updated_at
    end

    panel 'Events' do
      table_for ticket.events.order(created_at: :asc) do
        column :id
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
