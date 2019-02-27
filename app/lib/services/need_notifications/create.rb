# frozen_string_literal: true

module Services
  module NeedNotifications
    class Create
      include Procto.call
      include Concord.new(:need, :url)
      include Adamantium::Flat

      delegate :age_range_ids,
               :notified_user_ids, 
               :office, 
               :preferred_language, 
               :shifts, 
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
        SendTextMessageWorker.perform_async(user.phone, "A new need has opened up at your local office! #{url}")
      end

      def shift_users
        shifts.flat_map(&method(:users_for_shift)).uniq
      end

      def users_for_shift(shift)
        office
          .users
          .volunteerable
          .where.not(id: notified_user_ids | [user_id])
          .available_within(shift.start_at, shift.end_at)
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end

      def scope_users_by_language(users)
        return users unless preferred_language.present?

        users.speaks_language(preferred_language)
      end

      def scope_users_by_age_ranges(users)
        return users unless age_range_ids.any?

        users.joins(:age_ranges).where(age_ranges: { id: age_range_ids })
      end
    end
  end
end
