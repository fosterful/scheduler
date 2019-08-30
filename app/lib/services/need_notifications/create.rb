# frozen_string_literal: true

module Services
  module NeedNotifications
    class Create
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
        shift_users.tap do |u|
          u.each(&method(:notify_user))
          need.update(notified_user_ids: notify_user_ids)
        end
      end

      private

      def notify_user_ids
        notified_user_ids | shift_users.map(&:id)
      end

      def notify_user(user)
        SendTextMessageWorker
          .perform_async(user.phone,
                         "A new need starting #{starting_day} at "\
                           "#{start_at.strftime('%I:%M%P')} has opened up at "\
                           "your local office!  #{url}")
      end

      def shift_users
        shifts.flat_map(&method(:users_for_shift)).uniq
      end

      def starting_day
        start_at.today? ? 'Today' : start_at.strftime('%a, %b %e')
      end

      def users_for_shift(shift)
        office
          .users
          .volunteerable
          .with_phone
          .where.not(id: notified_user_ids | [user_id])
          .available_within(shift.start_at, shift.end_at)
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end
    end
  end
end
