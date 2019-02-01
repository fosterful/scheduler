# frozen_string_literal: true

module Services
  module NeedNotifications
    class Destroy
      include Procto.call
      include Concord.new(:need, :user_ids)
      include Adamantium::Flat

      delegate :office, :preferred_language, :user_id,
              :shifts, :notified_user_ids, :age_range_ids,
              to: :need

      def call
        shifts
          .flat_map { |shift| get_users_for_shift(shift) }
          .uniq
          .tap { |users| users.each { |user| SendTextMessageWorker.perform_async(user.phone, "A new need has opened up at your local office! #{need_url(need)}") } }
          .tap { |users| need.update(notified_user_ids: notified_user_ids | users.map(&:id)) }
      end

      private

      def get_users_for_shift(shift)
        office
          .users
          .volunteerable
          .where.not(id: notified_user_ids.push(user_id))
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
