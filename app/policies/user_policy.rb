# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :user, :other_user

  def initialize(user, other_user)
    @user = user
    @other_user = other_user
  end

  def new?
    authorize_role_assignment
  end

  def create?
    authorize_role_assignment && authorize_office_assignment
  end

  def destroy?
    user.admin? && user != other_user
  end

  def permitted_attributes_for_create
    permitted_attributes | %i(email role conviction conviction_desc)
  end

  def permitted_attributes_for_account_update
    [:email, *User::PROFILE_ATTRS]
  end

  def permitted_attributes
    [:email, { office_ids: [] }, *User::PROFILE_ATTRS].tap do |attrs|
      attrs << :role if user.admin?
    end
  end

  private

  def authorize_role_assignment
    return true if user.scheduler? && other_user == User

    case user.role
      when User::ADMIN
        true
      when User::COORDINATOR
        other_user.role.in? %w(volunteer social_worker)
      when User::SOCIAL_WORKER
        other_user.role.in? %w(volunteer social_worker)
      else
        false
    end
  end

  def authorize_office_assignment
    return true if user.admin?

    (other_user.offices - user.offices).empty?
  end
end
