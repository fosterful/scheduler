ActiveAdmin.register AgeRange do

  config.sort_order = 'id_asc'

  filter :min
  filter :max

  index do
    id_column
    column :min
    column :max
    actions
  end

   menu priority: 3

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :min, :max
  #
  # or
  #
  # permit_params do
  #   permitted = [:min, :max]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
