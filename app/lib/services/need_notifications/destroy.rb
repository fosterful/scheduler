# frozen_string_literal: true

module Services
  module NeedNotifications
    class Destroy
      include Procto.call
      include Concord.new(:need)
      include Adamantium::Flat

      delegate :office, :user_id, to: :need

      def call
        (office.users.schedulers | need.users).each do |user|
          SendTextMessageWorker
            .perform_async(user.phone,
                           "A need at #{office.name} has been deleted.")
        end
      end
    end
  end
end
