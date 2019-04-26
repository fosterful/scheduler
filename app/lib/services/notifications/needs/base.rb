# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Base
        include TextNotification
        include ActionView::Helpers
        include Rails.application.routes.url_helpers

        def initialize(need)
          self.need = need
        end

        def call
          send_messages

          yield if block_given?
        end

        protected

        attr_accessor :need

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
