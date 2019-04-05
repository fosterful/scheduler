# frozen_string_literal: true

module Services
  class NeedNotifier
    include Concord.new(:need, :action)
    include Procto.call

    def call
      case action
        when :create
          Services::Notifications::Needs::Create.call(need)
        when :update
          Services::Notifications::Needs::Update.call(need)
        when :destroy
          Services::Notifications::Needs::Destroy.call(need)
      end
    end
  end
end