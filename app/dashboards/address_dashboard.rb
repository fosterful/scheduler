# frozen_string_literal: true

require 'administrate/base_dashboard'

class AddressDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:                  Field::Number,
    street:              Field::String,
    street2:             Field::String,
    city:                Field::String,
    state:               Field::String,
    postal_code:         Field::String,
    skip_api_validation: Field::Boolean,
    latitude:            Field::Number.with_options(decimals: 2),
    longitude:           Field::Number.with_options(decimals: 2),
    created_at:          Field::DateTime,
    updated_at:          Field::DateTime
  }.freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i(
    street
    street2
    city
    state
    postal_code
    skip_api_validation
  ).freeze
end
