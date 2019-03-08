# frozen_string_literal: true

class AgeRangePolicy < ApplicationPolicy
  def permitted_attributes
    %i(min max)
  end
end
