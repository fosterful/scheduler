# frozen_string_literal: true

module Services
  module Notifications
    class TextNotification
      include AbstractType
      include ActionView::Helpers
      include Rails.application.routes.url_helpers
      include NotificationConcern
      include Procto.call

      def call
        TextMessageEnqueue.call(phone_numbers, message)
      end

      private

      abstract_method :phone_numbers, :message
    end
  end
end
