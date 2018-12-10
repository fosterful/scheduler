class OfficePolicy < ApplicationPolicy

  def permitted_attributes
    [:name, { address_attributes: %i[street street2 city state postal_code] }]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
