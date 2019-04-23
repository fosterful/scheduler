# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Create < Base
        include StartAtHelper

        delegate :notified_user_ids,
                 :shifts,
                 :start_at,
                 :users_to_notify,
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
          "A new need starting #{starting_day} at "\
            "#{start_at.strftime('%I:%M%P')} has opened up at your local " \
            "office!  #{url}"
        end

        def shift_users
          (users_to_notify | shifts.flat_map(&:users_to_notify)).uniq
        end

      end
    end
  end
end
