ActiveAdmin.register User do

  config.sort_order = 'last_name_asc'

  filter :first_name
  filter :last_name
  filter :email
  filter :offices

  form partial: 'form'
  form partial: 'edit'

  index do
    id_column
    column :name
    column :email
    column :offices
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :role
      row :time_zone
      row :race
      row :first_language
      row :second_language
      row :birth_date
      row :phone
      row :resident_since
      row :discovered_omd_by
      row :medical_limitations
      row :medical_limitations_desc
      row :conviction
      row :conviction_desc
      row :offices
      row :age_ranges
      row :invited_by
      row :unconfirmed_email
      row :sign_in_count
      row :current_sign_in_at
    end
  end

  menu priority: 1

  controller do
    def create_resource(object)
      object.invite!(current_user)
    end
  end
  # menu parent: 'offices'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :role, :invitation_token, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at, :invitation_limit, :invited_by_type, :invited_by_id, :invitations_count, :first_name, :last_name, :birth_date, :phone, :resident_since, :discovered_omd_by, :medical_limitations, :medical_limitations_desc, :conviction, :conviction_desc, :time_zone, :race_id, :first_language_id, :second_language_id
  
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :role, :invitation_token, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at, :invitation_limit, :invited_by_type, :invited_by_id, :invitations_count, :first_name, :last_name, :birth_date, :phone, :resident_since, :discovered_omd_by, :medical_limitations, :medical_limitations_desc, :conviction, :conviction_desc, :time_zone, :race_id, :first_language_id, :second_language_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
