# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Create
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :need, to: :shift

      def call
        msg = "A new shift has been added to a need at your local office! #{url}"
        users_to_notify.each do |user|
          SendTextMessageWorker.perform_async(user.phone, msg)
        end
      end

      private

      def users_to_notify
        need
          .office
          .users
          .volunteerable
          .available_within(shift.start_at, shift.end_at)
          .where.not(id: need.notified_user_ids.push(need.user_id))
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end

      def scope_users_by_language(users)
        return users unless need.preferred_language.present?

        users.speaks_language(need.preferred_language)
      end

      def scope_users_by_age_ranges(users)
        return users unless need.age_range_ids.any?

        users.joins(:age_ranges).where(age_ranges: { id: need.age_range_ids })
      end
    end
  end
end
