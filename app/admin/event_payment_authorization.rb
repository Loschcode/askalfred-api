
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
end
