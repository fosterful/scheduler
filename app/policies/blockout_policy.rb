class BlockoutPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [:start_at, :end_at, :rrule, :reason]
  end
end
