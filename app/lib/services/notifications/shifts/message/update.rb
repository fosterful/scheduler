# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Message
        class Update
          include Concord.new(:shift, :event_data)
          include Procto.call
          include Rails.application.routes.url_helpers
          include ShiftUpdateEventHelper
          include StartAtHelper

          delegate :duration,
                   :duration_in_words,
                   :need,
                   :start_at,
                   :user,
                   to: :shift

          def call
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
            "A Volunteer has taken the shift #{starting_day} from "\
              "#{duration_in_words}.".freeze
          end

          def shift_returned
            'A Volunteer has unassigned themself from the '\
              "#{duration_in_words} shift #{starting_day}.".freeze
          end

          def shift_assigned
            "You have been assigned a shift #{starting_day} from "\
              "#{duration_in_words}.".freeze
          end

          def shift_unassigned
            "You have been unassigned from the #{duration_in_words} shift "\
              "#{starting_day}.".freeze
          end
        end
      end
    end
  end
end
