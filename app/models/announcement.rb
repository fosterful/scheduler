# frozen_string_literal: true

class Announcement < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :author,
            :user_ids,
            presence: true

  validates :message,
            length:   { in: 5..160 },
            presence: true

  def send_messages
    Services::TextMessageEnqueue.send_messages(recipients, message)
  end

  private

  def recipients
    User.where(id: user_ids).announceable.pluck(:phone)
  end
end
