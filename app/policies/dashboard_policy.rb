# frozen_string_literal: true

class DashboardPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def users?
    user.role.in? [User::COORDINATOR, User::ADMIN]
  end

  def reports?
    user.role.in? [User::COORDINATOR, User::ADMIN, User::SOCIAL_WORKER]
  end
end
