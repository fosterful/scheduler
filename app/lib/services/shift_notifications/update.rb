# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Update
      include Procto.call
      include Concord.new(:shift, :current_user, :user_id_was)
      include Adamantium::Flat

      delegate :need, :duration, :user, to: :shift
      delegate :need_url, to: 'Rails.application.routes.url_helpers'

      def call
        notification_hash[:users].each do |user|
          SendTextMessageWorker.perform_async(user.phone, [notification_hash[:message], need_url(need)].join(' '))
        end
      end

      private

      def notification_hash
        if current_user == user && user
          { users:  (need.office.users.social_workers | [need.user]),
            message: 'A Volunteer has taken a shift.' }
        elsif user.nil? && current_user.id == user_id_was
          { users: (need.office.users.social_workers | [need.user]),
            message: 'A Volunteer has unassigned themself from a shift.' }
        elsif current_user.scheduler? && user
          { users: [user],
            message: 'You have been assigned a shift.' }
        elsif current_user.scheduler? && user.nil?
          { users: User.where(id: user_id_was),
            message: 'You have been unassigned from a shift' }
        else
          { users:[], message: '' }
        end
      end
    end
  end
end
