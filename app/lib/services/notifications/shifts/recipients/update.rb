# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Recipients
        class Update
          include Concord.new(:shift, :event_data)
          include ShiftUpdateEventHelper

          delegate :need,
                   :user,
                   to: :shift

          def recipients
            if shift_user_is_current_user? || current_user_left_shift?
              return social_workers_and_need_user
            end
            return [user] if scheduler_with_user?
            return [user_was] if scheduler_without_user?

            []
          end

          private

          def current_user
            event_data.fetch(:current_user, nil)
          end

          def user_was
            event_data.fetch(:user_was, nil)
          end

        end
      end
    end
  end
end
