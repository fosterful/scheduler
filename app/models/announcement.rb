# frozen_string_literal: true

class Announcement < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :message, presence: true
  validates :author, presence: true
  validates :user_ids, presence: true

  def send_messages
    Services::TextMessageEnqueue.send_messages(phone_numbers, message)
  end

  private

  def phone_numbers
    users.pluck(:phone).compact
  end

  def users
    User.where(id: user_ids).with_phone
  end
end
