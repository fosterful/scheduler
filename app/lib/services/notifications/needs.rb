# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      attr_accessor :message, :recipients

      def initialize(need, action, _event_data = {})
        self.message    = Message.new(need, action).message
        self.recipients = Recipients.new(need, action).recipients
      end

      def notify
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)

        yield(self) if block_given?
      end

      def phone_numbers
        recipients.map(&:phone)
      end
    end
  end
end
