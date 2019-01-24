# frozen_string_literal: true

class RacePolicy < ApplicationPolicy
  def permitted_attributes
    [:name]
  end
end
