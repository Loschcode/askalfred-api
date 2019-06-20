ActiveAdmin.register EventCallToAction do

permit_params :body,
              :label,
              :link,
              :created_at,
              :updated_at

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

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
