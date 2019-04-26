# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Base
        include TextNotification
        include ActionView::Helpers
        include Rails.application.routes.url_helpers

        def initialize(shift, current_user = nil, user_was = nil)
          self.shift        = shift
          self.current_user = current_user
          self.user_was     = user_was
        end

        def call
          send_messages
        end

        protected

        attr_accessor :shift, :current_user, :user_was

        private

        def phone_numbers
          raise NotImplementedError, '#phone_numbers is not implemented'
        end

        def message
          raise NotImplementedError, '#message is not implemented'
        end

        def url
          need_url(need)
        end
      end
    end
  end
end
