# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Update < Base

        SHIFT_TAKEN      = 'A Volunteer has taken a shift.'
        SHIFT_RETURNED   = 'A Volunteer has unassigned themself from a shift.'
        SHIFT_ASSIGNED   = 'You have been assigned a shift.'
        SHIFT_UNASSIGNED = 'You have been unassigned from a shift.'

        delegate :need, :duration, :user, to: :shift

        private

        def phone_numbers
          recipients.map(&:phone).compact
        end

        def message
          return SHIFT_TAKEN if user_is_current_user?
          return SHIFT_RETURNS if user_was_current_user?
          return SHIFT_ASSIGNED if scheduler_with_user?
          return SHIFT_UNASSIGNED if scheduler_without_user?

          nil
        end

        def recipients
          if user_is_current_user? || user_was_current_user?
            social_workers_and_need_user
          elsif scheduler_with_user?
            [user]
          elsif scheduler_without_user?
            User.where(id: user_id_was)
          else
            []
          end
        end

        def user_is_current_user?
          user.present? && user.eql?(current_user)
        end

        def user_was_current_user?
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

      end
    end
  end
end





