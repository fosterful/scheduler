# frozen_string_literal: true

module Services
  module NeedNotifications
    class Update
      include NotificationConcern
      include Procto.call
      include Concord.new(:need, :url)
      include Adamantium::Flat

      delegate :age_range_ids,
               :notified_user_ids,
               :office,
               :preferred_language,
               :shifts,
               :start_at,
               :user_id,
               to: :need

      def call
        users_to_notify.each do |user|
          SendTextMessageWorker
            .perform_async(user.phone,
                           "A new need starting #{starting_day} at "\
                             "#{start_at.strftime('%I:%M%P')} has opened up "\
                             "at your local office! #{url}")
        end
      end

      private

      def starting_day
        start_at.today? ? 'Today' : start_at.strftime('%a, %b %e')
      end

      def users_to_notify
        office
          .users
          .volunteerable
          .with_phone
          .where.not(id: notified_user_ids | [user_id])
          .available_within(shifts.first.start_at, shifts.last.end_at)
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end
    end
  end
end
