# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Update < Base

        delegate :age_range_ids,
                 :notified_user_ids,
                 :office,
                 :preferred_language,
                 :shifts,
                 :user_id,
                 to: :need

        private

        def phone_numbers
          users_to_notify.pluck(:phone)
        end

        def message
          "A new Need has opened up at your local office! #{url}"
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
end
