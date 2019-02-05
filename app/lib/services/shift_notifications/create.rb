# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Create
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :need, to: :shift

      def call
        notified_users.each do |user|
          SendTextMessageWorker.perform_async(user.phone, "A new shift has been added to a need at your local office! #{url}")
        end
      end

      private

      def notified_users
        need
          .office
          .users
          .volunteerable
          .available_within(shift.start_at, shift.end_at)
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