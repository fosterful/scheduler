# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Update
      include Procto.call
      include Concord.new(:shift, :url, :current_user)
      include Adamantium::Flat

      delegate :need, :duration, :user, :user_id_was, to: :shift

      def call
        notification_hash[:users].each do |user|
          SendTextMessageWorker.perform_async(user.phone, [notification_hash[:message], url].join(' '))
        end
      end

      private

      def notification_hash
        if current_user == user && user
          { users:  (need.office.users.social_workers | [need.user]),
            message: 'A Volunteer has taken a shift.' }
        elsif current_user == user && user.nil?
          { users: (need.office.users.social_workers | [need.user]),
            message: 'A Volunteer has unassigned themself from a shift.' }
        elsif current_user.scheduler? && user
          { users: [user],
            message: 'You have been assigned a shift.' }
        elsif current_user.scheduler? && user.nil?
          { users: User.where(id: user_id_was),
            message: 'You have been unassigned from a shift' }
        end
      end
    end
  end
end
