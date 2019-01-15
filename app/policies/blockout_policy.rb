class BlockoutPolicy < ApplicationPolicy
  def permitted_attributes
    [:start_at, :end_at, :rrule, :reason]
  end
end
