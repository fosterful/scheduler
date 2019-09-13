# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Recipients
        class Destroy
          include Adamantium::Flat
          include Concord.new(:shift, :_event_data)

          delegate :user,
                   to: :shift

          def recipients
            [user].compact
          end
        end
      end
    end
  end
end
