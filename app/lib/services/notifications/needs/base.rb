# frozen_string_literal: true

module Services
  module Notifications
    module Needs
      class Base < ::Services::Notifications::TextNotification
        include Adamantium::Flat
        include Concord.new(:need)

        private

        def url
          need_url(need)
        end
      end
    end
  end
end
