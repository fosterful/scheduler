# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Recipients
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

          klass.call(need).select(&:notifiable?)
        end
      end
    end
  end
end