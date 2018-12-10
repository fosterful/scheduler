class OfficePolicy < ApplicationPolicy
  def permitted_attributes
    [:name, { address_attributes: %i[street street2 city state postal_code] }]
  end
end
