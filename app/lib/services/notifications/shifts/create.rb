# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Create < Base
        include Concord.new(:shift)

        delegate :users_to_notify,
                 to: :shift

        private

        def phone_numbers
          users_to_notify.pluck(:phone)
        end

        def message
          "A new shift has been added to a need at your local office! #{url}"
        end

      end
    end
  end
end