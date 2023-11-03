# frozen_string_literal: true

ActiveAdmin.register User do # rubocop:disable Metrics/BlockLength

  config.sort_order = 'last_name_asc'

  scope 'Active users', :active, default: true
  scope 'Deactivated users', :deactivated
  scope :all

  filter :first_name
  filter :last_name
  filter :email
  filter :role, as: :select, collection: -> { User::ROLES }
  filter :offices

  form partial: 'form'

  %w(deactivate activate).each do |activation_type|
    member_action activation_type.to_sym, method: :post do
      unless resource.update(deactivated: !resource.deactivated)
        flash[:alert] = 'There was an issue updating this user.'
      end
      redirect_to admin_users_path
    end
  end

  # :nocov:
  index do
    id_column
    column :name, sortable: 'last_name'
    column :email
    column :offices
    column :role
    actions do |u|
      if u.deactivated
        link_to 'Activate', activate_admin_user_path(u.id), method: :post
      else
        link_to 'Deactivate', deactivate_admin_user_path(u.id), method: :post
      end
    end
  end
  # :nocov:

  show do
    attributes_table do
      rows  :first_name, :last_name, :email, :role, :time_zone, :race, :first_language,
            :second_language, :birth_date, :phone, :resident_since, :discovered_omd_by,
            :medical_limitations
      row :medical_limitations_desc do
        simple_format user.medical_limitations_desc
      end
      row :conviction
      row :conviction_desc do
        simple_format user.conviction_desc
      end
      row :offices do
        table_for user.offices do
          column :name
          column :region
          column :address
        end
      end
      rows :age_ranges, :invited_by, :unconfirmed_email, :sign_in_count
      row :current_sign_in_at do
        user.current_sign_in_at || 'Never signed in'
      end
    end
  end

  menu priority: 1

  controller do
    def create_resource(object)
      object.password = SecureRandom.hex(10)
      return false if object.invalid?

      object.invite!(current_user)
    end
  end
end
