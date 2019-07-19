# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Create
      include NotificationConcern
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :need,
               :start_at,
               :end_at,
               :duration,
               to: :shift
      delegate :age_range_ids,
               :notified_user_ids,
               :preferred_language,
               :user_id,
               to: :need

      def call
        msg = "A new shift from #{shift_duration_in_words} #{starting_day} "\
                "has been added to a need at your local office! #{url}"
        users_to_notify.each do |user|
          SendTextMessageWorker.perform_async(user.phone, msg)
        end
      end

      private

      def starting_day
        start_at.today? ? 'Today' : start_at.strftime('on %a, %b %e')
      end

      def shift_duration_in_words
        [start_at.strftime('%I:%M%P'), end_at.strftime('%I:%M%P')].join(' to ')
      end

      def users_to_notify
        need
          .office
          .users
          .volunteerable
          .available_within(shift.start_at, shift.end_at)
          .where.not(id: notified_user_ids.push(user_id))
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end
    end
  end
end
