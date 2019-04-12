# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Destroy < Base

        MSG = 'A Need at your office has been deleted.'

        delegate :office,
                 to: :need

        private

        def message
          MSG
        end

        def phone_numbers
          (office.users.schedulers | need.users).map(&:phone).compact
        end

        def url; end
      end
    end
  end
end
