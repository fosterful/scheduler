# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Base < ::Services::Notifications::TextNotification
        include Adamantium::Flat
        include ActionView::Helpers
        include Concord.new(:shift, :current_user, :user_id_was)
        include Rails.application.routes.url_helpers

        private

        def url
          need_url(need)
        end
      end
    end
  end
end
