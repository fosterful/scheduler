# frozen_string_literal: true

module Services
  module Notifications
    class Base < ::Services::Notifications::Base
      include AbstractType
      include ActionView::Helpers::UrlHelper
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
