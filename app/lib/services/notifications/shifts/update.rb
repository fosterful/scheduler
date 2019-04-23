# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Update < Base

        delegate :duration,
                 :need,
                 :user,
                 to: :shift

        private

        def phone_numbers
          recipients.map(&:phone).compact
        end

        def message
          return shift_taken if shift_user_is_current_user?
          return shift_returned if current_user_left_shift?
          return shift_assigned if scheduler_with_user?
          return shift_unassigned if scheduler_without_user?

          nil
        end

        def recipients
          if shift_user_is_current_user? || current_user_left_shift?
            social_workers_and_need_user
          elsif scheduler_with_user?
            [user]
          elsif scheduler_without_user?
            User.where(id: user_id_was)
          else
            []
          end
        end

        def shift_user_is_current_user?
          user.present? && user.eql?(current_user)
        end

        def current_user_left_shift?
          user.nil? && current_user.id.equal?(user_id_was)
        end

        def scheduler_with_user?
          current_user.scheduler? && user.present?
        end

        def scheduler_without_user?
          current_user.scheduler? && user.nil?
        end

        def social_workers_and_need_user
          need.office.social_workers | [need.user]
        end

        def shift_taken
          "A Volunteer has taken the shift #{starting_day} from #{shift_duration_in_words}."
        end

        def shift_returned
          "A Volunteer has unassigned themself from the #{shift_duration_in_words} shift #{starting_day}."
        end

        def shift_assigned
          "You have been assigned a shift #{starting_day} from #{shift_duration_in_words}."
        end

        def shift_unassigned
          "You have been unassigned from the #{shift_duration_in_words} shift #{starting_day}."
        end

        def shift_duration_in_words
          [start_at.strftime('%I:%M%P'), end_at.strftime('%I:%M%P')].join(' to ')
        end

        def starting_day
          return 'Today' if start_at.today?

          start_at.strftime('%a, %b %e')
        end

      end
    end
  end
end
