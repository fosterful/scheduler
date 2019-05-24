# frozen_string_literal: true

module Services
  module Notifications
    class TextNotification
      include Singleton

      def send_messages(phone_numbers, message)
        Services::TextMessageEnqueue.call(phone_numbers, message)
      end
    end
  end
end
