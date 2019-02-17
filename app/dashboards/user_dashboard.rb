# frozen_string_literal: true

require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    invited_by: Field::Polymorphic,
    id: Field::Number,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    confirmation_sent_at: Field::DateTime,
    unconfirmed_email: Field::String,
    failed_attempts: Field::Number,
    unlock_token: Field::String,
    locked_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::Number,
    last_sign_in_ip: Field::Number,
    role: Field::Select.with_options(collection: [''] | User::ROLES),
    invitation_token: Field::String,
    invitation_created_at: Field::DateTime,
    invitation_sent_at: Field::DateTime,
    invitation_accepted_at: Field::DateTime,
    invitation_limit: Field::Number,
    invitations_count: Field::Number,
    offices: Field::HasMany,
    age_ranges: Field::HasMany,
    race: Field::BelongsTo,
    first_language: Field::BelongsTo.with_options(class_name: 'Language'),
    second_language: Field::BelongsTo.with_options(class_name: 'Language'),
    first_name: Field::String,
    last_name: Field::String,
    birth_date: Field::DateTime,
    phone: Field::String,
    resident_since: Field::DateTime,
    discovered_omd_by: Field::Text,
    medical_limitations: Field::Boolean,
    medical_limitations_desc: Field::Text,
    conviction: Field::Boolean,
    conviction_desc: Field::Text,
    name: Field::MethodField,
    time_zone: Field::Select.with_options(collection: ActiveSupport::TimeZone.us_zones.map(&:name))
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :email,
    :offices,
    :id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :role,
    :time_zone,
    :race,
    :first_language,
    :second_language,
    :birth_date,
    :phone,
    :resident_since,
    :discovered_omd_by,
    :medical_limitations,
    :medical_limitations_desc,
    :conviction,
    :conviction_desc,
    :offices,
    :age_ranges,
    :invited_by,
    :unconfirmed_email,
    :created_at,
    :updated_at,
    :locked_at,
    :sign_in_count,
    :current_sign_in_at,
    :foobar
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :role,
    :race,
    :first_language,
    :second_language,
    :time_zone,
    :offices,
    :age_ranges,
    :birth_date,
    :phone,
    :resident_since,
    :discovered_omd_by,
    :medical_limitations,
    :medical_limitations_desc,
    :conviction,
    :conviction_desc
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user.name
  end
end
