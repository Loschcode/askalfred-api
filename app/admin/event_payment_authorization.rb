
ActiveAdmin.register EventPaymentAuthorization do
  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :body
    column :line_item
    column :amount_in_cents
    column :fees_in_cents
    column :authorized_at
    column :stripe_charge_id
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :email
  filter :body
  filter :line_item
  filter :amount_in_cents
  filter :fees_in_cents
  filter :authorized_at
  filter :stripe_charge_id
  filter :created_at
  filter :updated_at

  permit_params :email,
                :body,
                :line_item,
                :amount_in_cents,
                :fees_in_cents,
                :authorized_at,
                :stripe_charge_id,
                :created_at,
                :updated_at

  show email: :email do
    attributes_table do
      row :email
      row :body
      row :line_item
      row :amount_in_cents
      row :fees_in_cents
      row :authorized_at
      row :stripe_charge_id
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs 'Details' do
      input :body, as: :text
      input :line_item
      input :amount_in_cents
      input :fees_in_cents
      input :authorized_at
      input :stripe_charge_id
      input :created_at
      input :updated_at
    end
    actions
  end

  action_item :charge_customer, only: [:show, :edit], method: :get do
    link_to 'Charge customer', charge_customer_admin_event_payment_authorization_path(event_payment_authorization)
  end

  member_action :charge_customer, method: :get do
    event_payment_authorization = EventPaymentAuthorization.find(params[:id])
    event = event_payment_authorization.event
    identity = event.ticket.identity

    unless event_payment_authorization.authorized_at
      flash[:alert] = 'You have not been authorized by the customer to charge.'
      redirect_to action: :show
      return
    end

    if event_payment_authorization.stripe_charge_id
      flash[:alert] = 'You have already charge this customer.'
      redirect_to action: :show
      return
    end

    stripe_charge = begin
      Stripe::Charge.create(
        amount: event_payment_authorization.total_in_cents,
        currency: 'EUR',
        customer: identity.stripe_customer_id,
        source: identity.stripe_card_id,
        description: "Allowed expense for Event #{event.id}",
      )
    rescue Stripe::CardError => exception
      flash[:alert] = 'Problem when charging  this customer #{exception}.'
      return
    end

    event_payment_authorization.update stripe_charge_id: stripe_charge.id
    if event_payment_authorization.errors.any?
      flash[:alert] = "There were a problem updating the event BUT the customer was charged. Please check Stripe (#{event_payment_authorization.errors.full_messages.join(', ')}"
      return
    end

    flash[:notice] = 'Customer was charged sucessfully.'
    redirect_to action: :show, alert: 'Customer was charged sucessfully.'
  end
end
