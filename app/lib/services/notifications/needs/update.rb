# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Update < Base

        delegate :notified_user_ids,
                 :office,
                 :shifts,
                 :user_id,
                 :users_to_notify,
                 to: :need

        private

        def phone_numbers
          users_to_notify.pluck(:phone)
        end

        def message
          "A new Need has opened up at your local office! #{url}"
        end


      end
    end
  end
end
