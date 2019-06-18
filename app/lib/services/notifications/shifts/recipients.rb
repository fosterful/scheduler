# frozen_string_literal: true

module Services
  module Notifications
    class Shifts
      class Recipients
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

          klass
            .new(shift, event_data)
            .recipients
            .select(&:phone?)
        end
      end
    end
  end
end
