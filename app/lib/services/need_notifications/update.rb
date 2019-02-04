# frozen_string_literal: true

module Services
  module NeedNotifications
    class Update
      include Procto.call
      include Concord.new(:need, :url)
      include Adamantium::Flat

      delegate :preferred_language, :notified_user_ids, :age_range_ids, to: :need

      def call
        User.find(notified_user_ids).each do |user|
          SendTextMessageWorker.perform_async(user.phone, "A Need at your office has been updated. #{url}" )
        end
      end
    end
  end
end
