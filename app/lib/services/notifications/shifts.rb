# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      include Adamantium::Flat

      attr_accessor :message, :recipients, :shift

      def initialize(shift, action, event_data = {})
        self.message    = Message.new(shift, action, event_data).message
        self.recipients = Recipients.new(shift, action, event_data).recipients
        self.shift = shift
      end

      def notify
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)
        Services::EmailMessageEnqueue.send_messages(email_addresses, message)
        shift.need.notified_user_ids |= recipients.map(&:id)
        shift.need.save!

        yield(self) if block_given?
      end

      def phone_numbers
        recipients.select(&:receive_sms_notifications?).map(&:phone)
      end

      def email_addresses
        recipients.select(&:receive_email_notifications?).map(&:email)
      end
    end
  end
end
