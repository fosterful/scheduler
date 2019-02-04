# frozen_string_literal: true

module Services
  module NeedNotifications
    class Update
      include Procto.call
      include Concord.new(:need, :url)
      include Adamantium::Flat

      delegate :office, :preferred_language, :notified_user_ids,
               :age_range_ids, :shifts to: :need

      def call
        users_to_notify.each do |user|
          SendTextMessageWorker.perform_async(user.phone, "A new Need has opened up at your local office! #{url}" )
        end
      end

      private

      def users_to_notify
        office
          .users
          .volunteerable
          .where.not(id: notified_user_ids.push(user_id))
          .available_within(shifts.first.start_at, shifts.last.end_at)
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
