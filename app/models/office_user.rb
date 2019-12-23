# frozen_string_literal: true

class OfficeUser < ApplicationRecord
  belongs_to :office
  belongs_to :user
  scope :notifiable, -> { where(send_notifications: true) }
end
