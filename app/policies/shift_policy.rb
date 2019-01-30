# frozen_string_literal: true

class ShiftPolicy < ApplicationPolicy

  def create?
    user.admin? || (user_in_office? && user.scheduler?)
  end

  def index?
    create?
  end

  def new?
    create?
  end

  def update?
    create? || record.user == user || (user_in_office? && record.user.nil?)
  end

  def destroy?
    create?
  end

  def permitted_attributes_for_create
    permitted_attributes | %i[start_at duration]
  end

  def permitted_attributes
    %i[user_id]
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:need).where(needs: { office_id: user.office_ids })
      end
    end
  end

  private

  def user_in_office?
    user.id.in? record.need.office.user_ids
  end
end
