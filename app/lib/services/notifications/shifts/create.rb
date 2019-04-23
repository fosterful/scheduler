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
          "A new shift from #{shift_duration_in_words} #{starting_day} has "\
            "been added to a need at your local office! #{url}"
        end

        def phone_numbers
          users_to_notify.pluck(:phone)
        end

        def shift_duration_in_words
          [start_at.strftime('%I:%M%P'), end_at.strftime('%I:%M%P')].join(' to ')
        end

        def starting_day
          return 'Today' if start_at.today?

          start_at.strftime('%a, %b %e')
        end

      end
    end
  end
end
