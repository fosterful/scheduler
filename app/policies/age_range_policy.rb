# frozen_string_literal: true

class AgeRangePolicy < ApplicationPolicy
  def permitted_attributes
    [:min, :max]
  end
end
