# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Base
        include ActionView::Helpers
        include Rails.application.routes.url_helpers

        def initialize(shift, args = {}, notifier = default_notifier)
          self.shift        = shift
          self.current_user = args.fetch(:current_user, nil)
          self.user_was     = args.fetch(:user_was, nil)
          self.notifier     = notifier
        end

        def call
          notifier.send_messages(phone_numbers, message)
        end

        protected

        attr_accessor :shift, :current_user, :user_was

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
          Notifications::TextNotification.instance
        end
      end
    end
  end
end
