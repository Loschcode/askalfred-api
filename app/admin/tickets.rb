
ActiveAdmin.register Ticket do
  config.sort_order = 'created_at_desc'
  renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
  markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)

  index do
    id_column
    column :identity
    column :title
    column :canceled_at
    column :completed_at
    column :subject
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :canceled_at
  filter :completed_at
  filter :title
  filter :created_at
  filter :updated_at

  permit_params :identity_id,
                :title,
                :completed_at,
                :canceled_at,
                :created_at,
                :updated_at

  action_item :need_more_details, only: :show, method: :get do
    link_to 'I need more details (Email)', need_more_details_admin_ticket_path(ticket)
  end
  member_action :need_more_details, method: :get do
    ticket = Ticket.find(params[:id])
    IdentityMailer.with(identity: ticket.identity).alfred_needs_answers(ticket).deliver_later
    redirect_to action: :show, notice: 'Need more details sent'
  end

  action_item :end_request_successfully, only: :show, method: :get do
    link_to 'End request successfully (Email)', end_request_successfully_admin_ticket_path(ticket)
  end
  member_action :end_request_successfully, method: :get do
    ticket = Ticket.find(params[:id])
    ticket.update completed_at: Time.now, canceled_at: nil
    refresh_ticket_and_list(ticket)
    IdentityMailer.with(identity: ticket.identity).request_completed(ticket).deliver_later

    redirect_to({ action: :show } , notice: 'Request was ended')
  end

  action_item :cancel_request, only: :show, method: :get do
    link_to 'Cancel request (Email)', cancel_request_admin_ticket_path(ticket)
  end
  member_action :cancel_request, method: :get do
    ticket = Ticket.find(params[:id])
    ticket.update canceled_at: Time.now, completed_at: nil
    refresh_ticket_and_list(ticket)
    IdentityMailer.with(identity: ticket.identity).request_canceled(ticket).deliver_later
    redirect_to({ action: :show } , notice: 'Request was canceled')
  end

  show title: :title do
    attributes_table do
      row :identity
      row :name do |event| event.identity.first_name end
      row :title
      row :subject
      row :canceled_at
      row :completed_at
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
          if event.eventable_type == 'EventMessage'
            text_node markdown.render(event.eventable.body).html_safe
          end

          if event.eventable_type == 'EventFile'
            link_to 'File path', event.eventable.file_path
          end

          if event.eventable_type == 'EventPaymentAuthorization'
            text_node """
            #{markdown.render(event.eventable.body)}
            LINE ITEM #{event.eventable.line_items.map(&:label)}
            AMOUNT #{event.eventable.amount_in_cents}
            FEES #{event.eventable.fees_in_cents}
            AUTHORIZED AT #{event.eventable.authorized_at}
            """.html_safe
          end

          if event.eventable_type == 'EventDataCollectionForm'
            text_node """
            #{markdown.render(event.eventable.body)}
            LINE ITEM #{event.eventable.data_collections.map(&:slug)}
            SENT AT #{event.eventable.sent_at}
            """.html_safe
          end
          if event.eventable_type == 'EventCallToAction'
            text_node """
            #{markdown.render(event.eventable.body)}
            BUTTON BELOW #{markdown.render(event.eventable.label)} = #{event.eventable.link}
            """.html_safe
          end
        end
        column :seen_at
        column :created_at
        column :edit do |event|
          if event.eventable_type == "EventCallToAction"
            link_to 'Edit Call To Action', edit_admin_event_call_to_action_path(event.eventable.id)
          elsif event.eventable_type == "EventMessage"
            link_to 'Edit Message', edit_admin_event_message_path(event.eventable.id)
          elsif event.eventable_type == "EventPaymentAuthorization"
            link_to 'Edit Payment Authorization', edit_admin_event_payment_authorization_path(event.eventable.id)
          elsif event.eventable_type == "EventDataCollectionForm"
            link_to 'Edit Data Collection Form', edit_admin_event_data_collection_form_path(event.eventable.id)
          end
        end
      end
    end

    panel 'Send message' do
      active_admin_form_for EventMessage.new, url: { action: :send_event_message } do |f|
        f.inputs do
          f.input :body, as: :text
        end
        f.actions do
          f.action :submit, label: 'Create message'
        end
      end
    end

    panel 'Send call to action' do
      active_admin_form_for EventCallToAction.new, url: { action: :send_event_call_to_action } do |f|
        f.inputs do
          f.input :body, as: :text
          f.input :label
          f.input :link
        end
        f.actions do
          f.action :submit, label: 'Create call to action'
        end
      end
    end

    panel 'Send file' do
      active_admin_form_for EventFile.new, url: { action: :send_event_file } do |f|
        f.inputs do
          f.input :file, as: :file
        end
        f.actions do
          f.action :submit, label: 'Upload file'
        end
      end
    end

    panel 'Send payment authorization' do
      active_admin_form_for 'event_payment_authorization', url: { action: :send_event_payment_authorization } do |f|
        f.inputs do
          f.input :body, as: :text

          5.times do
            f.inputs do
              columns do
                column { f.input :'line_items[][label]', label: 'Label' }
                column { f.input :'line_items[][amount_in_cents]', label: 'Amount in cents' }
              end
            end
          end

          f.input :fees_in_cents, as: :select, collection: [:free, :automatic], prompt: true, selected: :automatic
        end
        f.actions do
          f.action :submit, label: 'Create payment authorization'
        end
      end
    end

    panel 'Send data collection form' do
      active_admin_form_for 'event_data_collection_form', url: { action: :send_event_data_collection_form } do |f|
        f.inputs do
          f.input :body, as: :text

          5.times do
            f.inputs do
              columns do
                column { f.input :'data_collections[][label]', label: 'Label' }
                column { f.input :'data_collections[][slug]', label: 'Slug' }
                column { f.input :'data_collections[][scope]', label: 'Scope', as: :select, prompt: true, selected: :identity, collection: [:identity, :ticket] }
              end
            end
          end
        end
        f.actions do
          f.action :submit, label: 'Create data collection form'
        end
      end
    end

    panel 'Emailing' do
      table_for ticket.mailbox_mails.order(created_at: :desc) do
        column :id do |mailbox_mail|
          a link_to(mailbox_mail.id, admin_mailbox_mail_path(mailbox_mail))
        end
        column :identity do |mailbox_mail|
          a link_to(mailbox_mail.identity.id, admin_identity_path(mailbox_mail.identity))
        end
        column :ticket do |mailbox_mail|
          if mailbox_mail.ticket
            a link_to(mailbox_mail.ticket.id, admin_ticket_path(mailbox_mail.ticket))
          end
        end
        column :from
        column :to
        column :subject
        column :created_at
        column :updated_at
      end

      panel 'Send email' do
        active_admin_form_for MailboxMail.new, url: { action: :send_email } do |f|
          f.inputs do
            text_node "<strong>From #{ticket.mailbox}</strong>".html_safe
            f.input :subject
            f.input :to
            f.input :body, as: :text
            text_node  'BE AWARE : THIS EMAIL WILL BE SENT AS TICKET RELATED EMAIL THROUGH THE SYSTEM, PLEASE USE THE MAILER  FROM THE IDENTITY DIRECTLY IF YOU DON\'T WANT THIS.'
          end
          f.actions do
            f.action :submit, label: 'Send email'
          end
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
        column :stripe_payment_intent_id
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

  member_action :send_email, method: :post do
    ticket = Ticket.find(params[:id])
    identity = ticket.identity
    to = params[:mailbox_mail][:to]
    subject = params[:mailbox_mail][:subject]
    body = params[:mailbox_mail][:body]

    MailboxService::Sender.new(
      identity: identity,
      ticket: ticket,
      to: to,
      subject: subject,
      body: body
    ).perform

    redirect_to action: :show
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

  member_action :send_event_message, method: :post do
    identity = Identity.where(role: 'admin').take
    ticket = Ticket.find(params[:id])
    body = params[:event_message][:body]

    SendMessageService.new(
      identity: identity,
      ticket: ticket,
      body: body
    ).perform

    redirect_to({ action: :show } , notice: 'Message was sent')
  end

  member_action :send_event_call_to_action, method: :post do
    identity = Identity.where(role: 'admin').take
    ticket = Ticket.find(params[:id])
    body = params[:event_call_to_action][:body]
    label = params[:event_call_to_action][:label]
    link = params[:event_call_to_action][:link]

    SendCallToActionService.new(
      identity: identity,
      ticket: ticket,
      body: body,
      link: link,
      label: label
    ).perform

    redirect_to({ action: :show } , notice: 'Call to action was sent')
  end

  member_action :send_event_payment_authorization, method: :post do
    identity = Identity.where(role: 'admin').take
    ticket = Ticket.find(params[:id])
    body = params[:event_payment_authorization][:body]
    fees_formula = params[:event_payment_authorization][:fees_in_cents].to_sym
    line_items = params[:event_payment_authorization][:line_items]

    SendPaymentAuthorizationService.new(
      identity: identity,
      ticket: ticket,
      body: body,
      line_items: line_items,
      fees_formula: fees_formula
    ).perform

    redirect_to({ action: :show } , notice: 'Payment authorization was sent')
  end

  member_action :send_event_data_collection_form, method: :post do
    identity = Identity.where(role: 'admin').take
    ticket = Ticket.find(params[:id])

    body = params[:event_data_collection_form][:body]
    data_collections = params[:event_data_collection_form][:data_collections]

    SendDataCollectionFormService.new(
      identity: identity,
      ticket: ticket,
      body: body,
      data_collections: data_collections,
    ).perform

    redirect_to({ action: :show } , notice: 'Data collection form was sent')
  end

  member_action :send_event_file, method: :post do
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
      input :canceled_at
      input :completed_at
      input :created_at
      input :updated_at
    end
    actions
  end

  controller do
    def update
      super
      refresh_ticket_and_list(resource)
    end
  end
end

def refresh_ticket_and_list(ticket)
  RefreshService.new(ticket.identity).tap do |refresh|
    refresh.ticket(ticket)
    refresh.tickets_list
  end
end
