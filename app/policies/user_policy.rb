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

  def reports?
    index?
  end

  def permitted_attributes_for_new
    permitted_attributes_for_create
  end

  def permitted_attributes_for_create
    permitted_attributes | %i[email role]
  end

  def permitted_attributes
    [:email, { office_ids: [] }, *User::PROFILE_ATTRS].tap do |attrs|
      attrs << :role if user.admin?
    end
  end

  private

  def authorize_role_assignment
    case user.role
    when 'admin'
      true
    when 'coordinator'
      other_user.role.in? %w[volunteer social_worker]
    when 'social_worker'
      other_user.role.in? %w[volunteer]
    else
      false
    end
  end

  def authorize_office_assignment
    return true if user.admin?
    (other_user.offices - user.offices).empty?
  end
end
