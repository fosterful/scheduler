# frozen_string_literal: true

# require 'app/lib/services/notifications/needs/message.rb'
# require 'app/lib/services/notifications/needs/recipients.rb'

module Services
  module Notifications
    class Needs
      # include Adamantium::Flat

      attr_accessor :message, :recipients

      def initialize(need, action, _event_data = {})
        self.message    = Message.call(need, action)
        self.recipients = Recipients.call(need, action)
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
