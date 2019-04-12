# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Create < Base

        delegate :need,
                 :users_to_notify,
                 to: :shift

        private

        def message
          "A new shift has been added to a need at your local office! #{url}"
        end

        def phone_numbers
          users_to_notify.pluck(:phone)
        end
     end
    end
  end
end
