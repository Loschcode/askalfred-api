ActiveAdmin.register EventMessage do
  permit_params :body,
                :created_at,
                :updated_at

  form do |f|
    inputs 'Details' do
      input :body, as: :text
      input :created_at
      input :updated_at
    end
    actions
  end
end
