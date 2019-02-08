# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Destroy
      include Procto.call
      include Concord.new(:shift, :url)
      include Adamantium::Flat

      delegate :user_id, to: :shift

      def call
        User.where(id: user_id).each do |user|
          SendTextMessageWorker.perform_async(user.phone, "A shift has been removed from a need at your local office. #{url}")
        end
      end
    end
  end
end
