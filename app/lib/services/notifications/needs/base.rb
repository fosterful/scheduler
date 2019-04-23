# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Base < ::Services::Notifications::TextNotification
        include ActionView::Helpers
        include Concord.new(:need)
        include Procto.call
        include Rails.application.routes.url_helpers

        private

        def url
          need_url(need)
        end
      end
    end
  end
end
