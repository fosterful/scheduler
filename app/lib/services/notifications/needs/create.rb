# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Create < Base

        delegate :age_range_ids,
                 :notified_user_ids,
                 :office,
                 :preferred_language,
                 :shifts,
                 :user_id,
                 to: :need

        def call
          super

          need.update(notified_user_ids: newly_notified_user_ids | notified_user_ids)
        end

        private

        def phone_numbers
          shift_users.map(&:phone).compact
        end

        def newly_notified_user_ids
          User.where(phone: phone_numbers).ids
        end

        def message
          "A new need has opened up at your local office! #{url}"
        end

        def shift_users
          shifts.flat_map(&method(:users_for_shift)).uniq
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
end
