ActiveAdmin.register EventCallToAction do

permit_params :body,
              :label,
              :link,
              :created_at,
              :updated_at

  form do |f|
    inputs 'Details' do
      input :body, as: :text
      input :label
      input :link
      input :created_at
      input :updated_at
    end
    actions
  end
end
