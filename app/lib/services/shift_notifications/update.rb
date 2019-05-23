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
               :end_at,
               :user,
               to: :shift

      def call
        send_confirmation if current_user == user && user
        notification_hash[:users].each do |notified_user|
          puts notification_hash[:message]
          SendTextMessageWorker.perform_async(notified_user.phone, [notification_hash[:message], need_url(need)].join(' '))
        end
      end

      private

      def shift_duration_in_words
        [start_at.strftime('%I:%M%P'), end_at.strftime('%I:%M%P')].join(' to ')
      end

      def starting_day
        start_at.today? ? 'Today' : start_at.strftime('on %a, %b %e')
      end

      def send_confirmation
        SendTextMessageWorker.perform_async(user.phone, "You have taken the shift #{starting_day} from #{shift_duration_in_words}. #{need_url(need)}")
      end

      def notification_hash
        if current_user == user && user
          { users: (need.office.users.social_workers | [need.user]),
            message: "#{user.first_name} #{user.last_name} has taken the shift #{starting_day} from #{shift_duration_in_words}." }
        elsif user.nil? && current_user.id == user_id_was
          { users: (need.office.users.social_workers | [need.user]),
            message: "#{current_user.first_name} #{current_user.last_name} has unassigned themself from the #{shift_duration_in_words} shift #{starting_day}." }
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
