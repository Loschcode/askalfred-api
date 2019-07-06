
ActiveAdmin.register Identity do
  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :email
    column :first_name
    column :last_name
    column :encrypted_password
    column :role
    column :mailbox
    column :token
    column :confirmed_at
    column :confirmation_sent_at
    column :confirmation_token
    column :recovery_token
    column :stripe_customer_id
    column :stripe_payment_method_id
    column :terms_accepted_at
    column :email_opt_out_at
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :email
  filter :first_name
  filter :last_name
  filter :role
  filter :confirmation_token
  filter :recovery_token
  filter :stripe_customer_id
  filter :stripe_payment_method_id
  filter :created_at
  filter :updated_at

  permit_params :email,
                :first_name,
                :last_name,
                :encrypted_password,
                :role,
                :mailbox,
                :token,
                :confirmed_at,
                :confirmation_sent_at,
                :confirmation_token,
                :recovery_token,
                :stripe_customer_id,
                :stripe_payment_method_id,
                :terms_accepted_at,
                :email_opt_out_at,
                :created_at,
                :updated_at

  show email: :email do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :encrypted_password
      row :role
      row :mailbox
      row :token
      row :confirmed_at
      row :confirmation_sent_at
      row :confirmation_token
      row :recovery_token
      row :stripe_customer_id
      row :stripe_payment_method_id
      row :terms_accepted_at
      row :email_opt_out_at
      row :created_at
      row :updated_at
    end


    panel 'Emailing' do
      table_for identity.mailbox_mails.order(created_at: :desc) do
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
        column :direction
        column :subject
        column :created_at
        column :updated_at
      end

      panel 'Send email' do
        active_admin_form_for MailboxMail.new, url: { action: :send_email } do |f|
          f.inputs do
            f.input :subject
            f.input :to
            f.input :body, as: :text
          end
          f.actions do
            f.action :submit, label: 'Send email'
          end
        end
      end
    end
  end

  member_action :send_email, method: :post do
    identity = Identity.find(params[:id])
    to = params[:mailbox_mail][:to]
    subject = params[:mailbox_mail][:subject]
    body = params[:mailbox_mail][:body]

    MailboxService::Sender.new(
      identity: identity,
      to: to,
      subject: subject,
      body: body
    ).perform

    redirect_to action: :show
  end
end
