class LanguagePolicy < ApplicationPolicy
  def permitted_attributes
    [:name]
  end
end
