
ActiveAdmin.register EventDataCollectionForm do
  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :body
    column :data_collections
    column :sent_at
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :email
  filter :body
  filter :data_collections
  filter :sent_at
  filter :created_at
  filter :updated_at

  permit_params :email,
                :body,
                :data_collections,
                :sent_at,
                :created_at,
                :updated_at

  show email: :email do
    attributes_table do
      row :email
      row :body
      row :data_collections
      row :sent_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs 'Details' do
      input :body, as: :text
      input :data_collections
      input :sent_at
      input :created_at
      input :updated_at
    end
    actions
  end
end
