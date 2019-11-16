ActiveAdmin.register Office do

  config.sort_order = 'id_asc'

  filter :name
  filter :region
  filter :address

  form partial: 'form'

  index do
    id_column
    column :name
    column :region
    column :address
    actions
  end

  menu priority: 2

  controller do
    def new
      super do
        resource.build_address if resource.address.blank?
      end
    end
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
