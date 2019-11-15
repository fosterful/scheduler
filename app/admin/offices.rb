ActiveAdmin.register Office do

  filter :name
  filter :region
  filter :address

  index do
    id_column
    column :name
    column :region
    column :address
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :region
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :region]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
