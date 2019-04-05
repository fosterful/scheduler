# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Destroy < Base
        include Concord.new(:shift)

        delegate :need,
                 :user_id,
                 to: :shift

        private

        def phone_numbers
          User.where(id: user_id).pluck(:phone)
        end

        def message
          "A shift has been removed from a need at your local office. #{url}"
        end

      end
    end
  end
end
