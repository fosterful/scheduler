# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Create < Base
        include StartAtHelper

        delegate :duration_in_words,
                 :need,
                 :start_at,
                 :users_to_notify,
                 to: :shift

        private

        def message
          "A new shift from #{duration_in_words} #{starting_day} has been "\
            "added to a need at your local office! #{url}"
        end

        def phone_numbers
          users_to_notify.pluck(:phone)
        end
      end
    end
  end
end
