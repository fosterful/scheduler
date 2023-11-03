# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Message
        class Update
          include Concord.new(:shift, :event_data)
          include Rails.application.routes.url_helpers
          include ShiftUpdateEventHelper
          include StartAtHelper

          delegate :duration,
                   :duration_in_words,
                   :need,
                   :start_at,
                   :user,
                   to: :shift

          def message
            return shift_taken if shift_user_is_current_user?
            return shift_returned if current_user_left_shift?
            return shift_assigned if scheduler_with_user?

            shift_unassigned if scheduler_without_user?
          end

          private

          def current_user
            event_data.fetch(:current_user, nil)
          end

          def user_was
            event_data.fetch(:user_was, nil)
          end

          def shift_taken
            "#{current_user} has taken the shift #{starting_day} from " \
              "#{duration_in_words}."
          end

          def shift_returned
            "#{current_user} has unassigned themself from the " \
              "#{duration_in_words} shift #{starting_day}."
          end

          def shift_assigned
            'Thanks for your help. See you soon!'
          end

          def shift_unassigned
            "You have been unassigned from the #{duration_in_words} shift " \
              "#{starting_day}."
          end
        end
      end
    end
  end
end
