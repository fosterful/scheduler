# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Message
        class Destroy
          include Adamantium::Flat
          include Concord.new(:need)

          delegate :office,
                   to: :need

          def message
            "A need at #{office.name} has been deleted.".freeze
          end
        end
      end
    end
  end
end
