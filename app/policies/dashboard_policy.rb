# frozen_string_literal: true

class DashboardPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def reports?
    user.role.in? [User::COORDINATOR, User::ADMIN]
  end

  def download_report?
    user.role.in? [User::COORDINATOR, User::ADMIN]
  end
end
