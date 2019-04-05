# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Destroy < Base

        MSG = 'A Need at your office has been deleted.'

        delegate :office, :user_id, to: :need

        private

        def phone_numbers
          (office.users.schedulers | need.users).map(&:phone).compact
        end

        def message
          MSG
        end
      end
    end
  end
end