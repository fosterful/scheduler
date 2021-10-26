# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      attr_accessor :message, :recipients, :need

      def initialize(need, action, _event_data = {})
        self.message    = Message.new(need, action).message
        self.recipients = Recipients.new(need, action).recipients
        self.need = need
      end

      def notify
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)
        Services::EmailMessageEnqueue.send_messages(email_addresses, message)
        unless need.destroyed?
          need.notified_user_ids |= recipients.map(&:id)
          need.save!
        end

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
