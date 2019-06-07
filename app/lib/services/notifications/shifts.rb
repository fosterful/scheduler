# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      include Adamantium::Flat

      attr_accessor :message,
                    :recipients

      def initialize(shift, action, event_data = {})
        self.message    = Message.call(shift, action, event_data)
        self.recipients = Recipients.call(shift, action, event_data)
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
