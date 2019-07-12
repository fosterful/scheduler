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

        def message
          klass = case action
                    when :create
                      Create
                    when :update
                      Update
                    when :destroy
                      Destroy
                  end

          klass.new(need).message
        end
      end
    end
  end
end
