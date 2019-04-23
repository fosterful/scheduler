# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Destroy < Base

        delegate :office,
                 to: :need

        private

        def message
          "A need at #{office.name} has been deleted."
        end

        def phone_numbers
          (office.users.schedulers | need.users).map(&:phone).compact
        end

        def url; end
      end
    end
  end
end
