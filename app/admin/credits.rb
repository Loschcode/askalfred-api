
ActiveAdmin.register Credit do
  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :identity
    column :ticket_title
    column :time
    column :origin
    column :stripe_payment_intent_id
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :identity
  filter :ticket_id
  filter :time
  filter :origin
  filter :stripe_payment_intent_id
  filter :created_at
  filter :updated_at

  permit_params :identity_id,
                :ticket_id,
                :time,
                :origin,
                :stripe_payment_intent_id,
                :created_at,
                :updated_at

  show id: :id do
    attributes_table do
      row :identity
      row :ticket_title
      row :time
      row :origin
      row :stripe_payment_intent_id
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      input :identity_id, as: :select, collection: Identity.all.map { |identity| ["#{identity.first_name} #{identity.last_name}", identity.id]}
      input :ticket_id, as: :select, collection: Ticket.all.map { |ticket| ["#{ticket.title} #{ticket.id}", ticket.id]}
      input :time
      input :origin
      input :created_at
      input :updated_at
    end

    f.actions
  end
end