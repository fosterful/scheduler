# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Recipients
        class Create
          include Adamantium::Flat
          include Concord.new(:shift, :_event_data)
          include Procto.call

          delegate :users_to_notify,
                   to: :shift

          def recipients
            users_to_notify
          end
        end
      end
    end
  end
end
