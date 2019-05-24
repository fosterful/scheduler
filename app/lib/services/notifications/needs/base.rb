# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Base
        include ActionView::Helpers
        include Rails.application.routes.url_helpers

        def initialize(need, notifier = default_notifier)
          self.need = need
          self.notifier = notifier
        end

        def call
          notifier.send_messages(phone_numbers, message)

          yield if block_given?
        end

        protected

        attr_accessor :need

        private

        attr_accessor :notifier

        def phone_numbers
          raise NotImplementedError, '#phone_numbers is not implemented'
        end

        def message
          raise NotImplementedError, '#message is not implemented'
        end

        def url
          need_url(need)
        end

        def default_notifier
          TextNotification.instance
        end
      end
    end
  end
end
