# frozen_string_literal: true

class AnnouncementPolicy < ApplicationPolicy

  delegate :admin?, to: :user

  def index?
    admin?
  end

  def show?
    admin?
  end

  def new?
    admin?
  end

  def create?
    admin?
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
    %i(message)
  end
end