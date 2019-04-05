# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Create < Base
        include Concord.new(:shift)

        delegate :end_at,
                 :need,
                 :start_at,
                 to: :shift

        delegate :age_range_ids,
                 :notified_user_ids,
                 :preferred_language,
                 :user_id,
                 to: :need

        private

        def phone_numbers
          users_to_notify.pluck(:phone)
        end

        def message
          "A new shift has been added to a need at your local office! #{url}"
        end

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
      end
    end
  end
end