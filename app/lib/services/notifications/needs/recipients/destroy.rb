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
            User.notifiable(office.users.schedulers) | User.notifiable(need.users)
          end
        end
      end
    end
  end
end
