# frozen_string_literal: true

class AnnouncementPolicy < ApplicationPolicy

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def permitted_attributes
    [:message, { user_ids: [] }]
  end
end
