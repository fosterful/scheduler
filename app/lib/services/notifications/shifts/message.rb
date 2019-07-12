# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Message
        include Adamantium::Flat
        include Concord.new(:shift, :action, :event_data)

        def message
          klass = case action
                    when :create
                      Create
                    when :update
                      Update
                    when :destroy
                      Destroy
                  end

          klass.new(shift, event_data).message
        end

      end
    end
  end
end
