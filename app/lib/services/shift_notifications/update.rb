# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Update
      include Procto.call
      include Concord.new(:shift, :current_user, :user_id_was)
      include Adamantium::Flat
      include Rails.application.routes.url_helpers

      delegate :need,
               :duration,
               :start_at,
               :user,
               to: :shift


      def call
        notification_hash[:users].each do |user|
          SendTextMessageWorker.perform_async(user.phone, [notification_hash[:message], need_url(need)].join(' '))
        end
      end

      private

      def shift_duration_in_words
        [start_at.strftime('%l:%M'), start_at.strftime('%l:%M %p')].join(' to ')
      end

      def starting_day
        start_at.today? ? 'Today' : start_at.strftime('on %a, %b %e')
      end

      def notification_hash
        if current_user == user && user
          { users: (need.office.users.social_workers | [need.user]),
            message: "A Volunteer has taken the shift #{starting_day} from #{shift_duration_in_words}." }
        elsif user.nil? && current_user.id == user_id_was
          { users: (need.office.users.social_workers | [need.user]),
            message: "A Volunteer has unassigned themself from the #{shift_duration_in_words} shift #{starting_day}." }
        elsif current_user.scheduler? && user
          { users: [user],
            message: "You have been assigned a shift #{starting_day} from #{shift_duration_in_words}." }
        elsif current_user.scheduler? && user.nil?
          { users: User.where(id: user_id_was),
            message: "You have been unassigned from the #{shift_duration_in_words} shift #{starting_day}." }
        else
          { users: [], message: '' }
        end
      end
    end
  end
end
