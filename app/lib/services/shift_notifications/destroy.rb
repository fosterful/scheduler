# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Destroy
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :user,
               :start_at,
               :end_at,
               to: :shift

      def call
        return if user.nil?

        msg = "The shift from #{shift_duration_in_words} has been removed "\
                "from a need at your local office. #{url}"
        SendTextMessageWorker.perform_async(user.phone, msg)
      end

      private

      def shift_duration_in_words
        [start_at.strftime('%I:%M%P'), end_at.strftime('%I:%M%P')].join(' to ')
      end
    end
  end
end
