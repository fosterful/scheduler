# frozen_string_literal: true

class AnnouncementPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

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
    [:message]
  end
end