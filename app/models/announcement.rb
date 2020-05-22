# frozen_string_literal: true

class Announcement < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :author,
            :message,
            :user_ids,
            presence: true

  def send_messages
    Services::TextMessageEnqueue.send_messages(recipients, message)
  end

  private

  def recipients
    User.where(id: user_ids).announceable.pluck(:phone)
  end
end
