# frozen_string_literal: true

module Services
  module NeedNotifications
    class Destroy
      include Procto.call
      include Concord.new(:need)
      include Adamantium::Flat

      MSG = 'A Need at your office has been deleted.'.freeze

      delegate :office, :user_id, to: :need

      def call
        (office.users.schedulers | need.users).each do |user|
          SendTextMessageWorker.perform_async(user.phone, MSG)
        end
      end
    end
  end
end
