# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Destroy < Base
        delegate :duration_in_words,
                 :need,
                 :user_id,
                 to: :shift

        private

        def message
          "The shift from #{duration_in_words} has been removed from a "\
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
