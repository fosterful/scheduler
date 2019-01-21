class RacePolicy < ApplicationPolicy
  def permitted_attributes
    [:name]
  end
end
