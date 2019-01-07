class AgeRangePolicy < ApplicationPolicy
  def permitted_attributes
    [:min, :max]
  end
end
