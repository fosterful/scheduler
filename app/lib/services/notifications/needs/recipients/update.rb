# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Recipients
        class Update
          include Concord.new(:need)
          include Procto.call

          delegate :users_to_notify,
                   to: :need

          def call
            users_to_notify
          end
        end
      end
    end
  end
end
