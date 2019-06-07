# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Message
        class Create
          include Adamantium::Flat
          include Concord.new(:shift, :_event_data)
          include Procto.call
          include Rails.application.routes.url_helpers
          include StartAtHelper

          delegate :duration_in_words,
                   :need,
                   :start_at,
                   to: :shift

          def call
            "A new shift from #{duration_in_words} #{starting_day} has been "\
              "added to a need at your local office! #{url}".freeze
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
