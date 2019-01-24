# frozen_string_literal: true

class LanguagePolicy < ApplicationPolicy
  def permitted_attributes
    [:name]
  end
end
