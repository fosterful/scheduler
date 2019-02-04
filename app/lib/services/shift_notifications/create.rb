# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Create
      include Procto.call
      include Concord.new(:shift, :message_type, :url)
      include Adamantium::Flat

      delegate :need, :duration, :user, to: :shift

      def call
        who_to_send_to.each do |user|
          SendTextMessageWorker.perform_async(user.phone, ['A new shift has been added to a need at your local office!', need_url(need)].join(' '))
        end
      end
    end
  end
end
