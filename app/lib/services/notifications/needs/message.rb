# frozen_string_literal: true

# require 'app/lib/services/notifications/needs/message/create'
# require 'app/lib/services/notifications/needs/message/update'
# require 'app/lib/services/notifications/needs/message/destroy'

module Services
  module Notifications
    class Needs
      class Message
        include Adamantium::Flat
        include Concord.new(:need, :action)
        include Procto.call

        def call
          klass = case action
                    when :create
                      Create
                    when :update
                      Update
                    when :destroy
                      Destroy
                  end

          klass.call(need)
        end
      end
    end
  end
end
