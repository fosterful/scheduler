# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Message
        class Destroy
          include Adamantium::Flat
          include Concord.new(:shift, :_event_data)
          include Procto.call
          include Rails.application.routes.url_helpers

          delegate :duration_in_words,
                   to: :shift

          def call
            "The shift from #{duration_in_words} has been removed from a need "\
              "at your local office. #{needs_url}"
          end

        end
      end
    end
  end
end
