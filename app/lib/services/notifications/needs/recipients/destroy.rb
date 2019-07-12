# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Recipients
        class Destroy
          include Adamantium::Flat
          include Concord.new(:need)
          include Procto.call

          delegate :office,
                   to: :need

          def recipients
            office.users.schedulers | need.users
          end
        end
      end
    end
  end
end
