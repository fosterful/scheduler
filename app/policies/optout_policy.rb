# frozen_string_literal: true

class OptoutPolicy < ApplicationPolicy
  def create?
    user.admin? || user_in_office?
  end

  def update?
    create?
  end

  private

  def user_in_office?
    record.need.office&.user_ids&.include? user.id
  end
end
