# frozen_string_literal: true

module Services
  class EmailMessageEnqueue

    def self.send_messages(email_addresses, message)
      email_addresses.each do |email_address|
        UserMailer.with(email: email_address, message: message).notification_email.deliver_later
      end
    end
  end
end