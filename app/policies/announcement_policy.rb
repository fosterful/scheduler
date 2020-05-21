# frozen_string_literal: true

class AnnouncementPolicy < ApplicationPolicy
  def permitted_attributes
    [:message]
  end
end