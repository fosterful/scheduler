# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Destroy
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :need, :duration, to: :shift

      def call
        (notified_users | User.where(id: shift.user_id)).each do |user|
          SendTextMessageWorker.perform_async(user.phone, "A shift has been removed from a need at your local office. #{url}")
        end
      end

      private

      def notified_users
        need
          .office
          .users
          .schedulers
      end
    end
  end
end
