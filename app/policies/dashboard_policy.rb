# frozen_string_literal: true

class DashboardPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def dashboard?
    user.role.in? [User::COORDINATOR, User::ADMIN]
  end
end
