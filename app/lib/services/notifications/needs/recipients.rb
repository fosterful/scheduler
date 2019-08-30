# frozen_string_literal: true

module Services
  module Notifications
    class Needs
      class Recipients
        include Adamantium::Flat
        include Concord.new(:need, :action)

        def recipients
          klass = case action
                    when :create
                      Create
                    when :update
                      Update
                    when :destroy
                      Destroy
                  end

          klass.new(need).recipients
        end
      end
    end
  end
end
