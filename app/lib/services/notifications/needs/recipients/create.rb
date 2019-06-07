# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Recipients
        class Create
          include Adamantium::Flat
          include Concord.new(:need)
          include Procto.call

          delegate :shifts,
                   :users_to_notify,
                   to: :need

          def call
            (users_to_notify | shifts.flat_map(&:users_to_notify)).uniq
          end
        end
      end
    end
  end
end
