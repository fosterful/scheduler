# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Message
        class Create
          include Adamantium::Flat
          include Concord.new(:need)
          include Rails.application.routes.url_helpers
          include StartAtHelper

          delegate :start_at, :office,
                   to: :need

          def message
            "Your help is needed at the child welfare office (in #{office.name}). Click here to respond yes/no: #{url}"
          end

          private

          def url
            need_url(need)
          end
        end
      end
    end
  end
end
