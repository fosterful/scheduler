# frozen_string_literal: true

module Services
  module NeedNotifications
    class Update
      include NotificationConcern
      include Procto.call
      include Concord.new(:need, :url)
      include Adamantium::Flat

      delegate :office, :preferred_language, :notified_user_ids,
               :age_range_ids, :shifts, :user_id, to: :need

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
          .with_phone
          .where.not(id: notified_user_ids | [user_id])
          .available_within(shifts.first.start_at, shifts.last.end_at)
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end
    end
  end
end
