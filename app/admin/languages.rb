ActiveAdmin.register Language do

  config.sort_order = 'id_asc'

  filter :name
  filter :id
  filter :name

  index do
    id_column
    column :name
    actions
  end

   menu priority: 5

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
