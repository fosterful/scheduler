# frozen_string_literal: true

module TextNotification

  # Including modules need to ensure that both `phone_numbers` and `message` are
  # defined and available
  def send_messages
    Services::TextMessageEnqueue.call(phone_numbers, message)
  end

end
