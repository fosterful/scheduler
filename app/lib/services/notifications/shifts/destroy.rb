# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Destroy < Base
        delegate :need,
                 :user_id,
                 to: :shift

        private

        def message
          "The shift from #{shift_duration_in_words} has been removed from a "\
            "need at your local office. #{url}"
        end

        def phone_numbers
          User.where(id: user_id).pluck(:phone)
        end

        def url
          needs_url
        end

      end
    end
  end
end
