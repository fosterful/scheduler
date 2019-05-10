# frozen_string_literal: true

module Services
  class NeedNotifier
    include Concord.new(:need, :action)
    include Procto.call

    def call
      klass = case action
                when :create
                  Services::Notifications::Needs::Create
                when :update
                  Services::Notifications::Needs::Update
                when :destroy
                  Services::Notifications::Needs::Destroy
              end

      klass.new(need).call
    end
  end
end
