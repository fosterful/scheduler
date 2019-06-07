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
              social_workers_and_need_user
            elsif scheduler_with_user?
              [user]
            elsif scheduler_without_user?
              [user_was]
            else
              []
            end
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
