# frozen_string_literal: true

class OfficeUser < ApplicationRecord
  belongs_to :office
  belongs_to :user
  scope :notifiable, -> {
    joins(:user).where(send_notifications: true).where(users: { deactivated: false })
  }
end
