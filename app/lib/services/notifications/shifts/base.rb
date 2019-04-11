# frozen_string_literal: true

module Services
  module Notifications
    module Shifts
      class Base < ::Services::Notifications::TextNotification
        include Adamantium::Flat
        include Concord.new(:shift, :current_user, :user_id_was)

        private

        def url
          need_url(need)
        end
      end
    end
  end
end
