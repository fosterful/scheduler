# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Create
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :need, to: :shift
      delegate :notified_user_ids, :user_id, :preferred_language, :age_range_ids, to: :need

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
          .where.not(id: notified_user_ids.push(user_id))
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
