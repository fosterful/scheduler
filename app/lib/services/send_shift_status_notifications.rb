# frozen_string_literal: true

module Services
  class SendShiftStatusNotifications
    include Procto.call
    include Concord.new(:shift, :message_type, :url)
    include Adamantium::Flat

    delegate :need, :duration, :user, to: :shift

    MESSAGE_HASH = {
      created: 'A new shift has been added to a need at your local office!',
      updated: ''
    }

    def call
      $twilio.api.account.messages.create(from: '+15005550006',
                                          to: '+14049812386',
                                          body: [MESSAGE_HASH[message_type], url].join(' '))
    end
  end
end
