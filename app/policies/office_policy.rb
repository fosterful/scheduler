# frozen_string_literal: true

class OfficePolicy < ApplicationPolicy
  def permitted_attributes
    [:name,
     :region,
     { address_attributes: %i(street
                              street2
                              city
                              state
                              postal_code
                              skip_api_validation) }]
  end
end
