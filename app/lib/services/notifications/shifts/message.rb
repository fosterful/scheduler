# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Message
        include Adamantium::Flat
        include Concord.new(:shift, :action, :event_data)
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

          klass.call(shift, event_data)
        end

      end
    end
  end
end
