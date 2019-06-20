
ActiveAdmin.register Event do
  config.sort_order = 'created_at_desc'
  renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
  markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)

  index do
    id_column
    column :identity
    column :ticket_title
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :identity
  filter :ticket_id
  filter :created_at
  filter :updated_at

  permit_params :identity_id,
                :ticket_id,
                :created_at,
                :updated_at

  show id: :id do
    attributes_table do
      row :identity
      row :ticket_title
      row :created_at
      row :updated_at
      if event.eventable_type == 'EventMessage'
        row :event_message, link_to(event.id, admin_event_message_path(event.event_message))
      end
      if event.eventable_type == 'EventCallToAction'
        row :event_call_to_action, link_to(event.id, admin_event_call_to_action_path(event.event_call_to_action))
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      input :identity_id, as: :select, collection: Identity.all.map { |identity| ["#{identity.first_name} #{identity.last_name}", identity.id]}
      input :ticket, as: :select, collection: Ticket.all.map { |ticket| ["#{ticket.title} #{ticket.id}", ticket.id]}
      input :eventable_type
      input :created_at
      input :updated_at
    end

    f.actions
  end
end
