# frozen_string_literal: true

module Services
  module NeedNotifications
    class Destroy
      include Procto.call
      include Concord.new(:need, :user_ids)
      include Adamantium::Flat

      delegate :office, :user_id, to: :need

      def call
        (office.users.schedulers | User.find(user_ids)).each do |user|
          SendTextMessageWorker.perform_async(user.phone, 'Need has been deleted.')
        end
      end
    end
  end
end
