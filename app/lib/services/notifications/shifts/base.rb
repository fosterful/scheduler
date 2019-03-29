# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Base < ::Services::Notifications::Base
        include Concord.new(:shift)

        private

        def url
          shift_url(shift)
        end
      end
    end
  end
end
