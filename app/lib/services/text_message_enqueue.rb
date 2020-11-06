# frozen_string_literal: true

module Services
  class TextMessageEnqueue
    def self.send_messages(phone_numbers, message)
      phone_numbers.each do |phone_number|
        SendTextMessageWorker.perform_async(phone_number, message)
      end
    end
  end
end
