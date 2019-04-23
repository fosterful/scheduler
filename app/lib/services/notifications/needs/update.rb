# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Update < Base
        include StartAtHelper

        delegate :users_to_notify,
                 to: :need

        private

        def phone_numbers
          users_to_notify.pluck(:phone)
        end

        def message
          "A new need starting #{starting_day} at #{start_time} has opened up "\
            "at your local office! #{url}"
        end
      end
    end
  end
end
