# frozen_string_literal: true

module Services
  class ShiftNotifier
    include Procto.call

    def initialize(shift, action, user_is = nil, user_was = nil)
      @shift    = shift
      @action   = action
      @user_is  = user_is
      @user_was = user_was
    end

    def call
      case action
        when :create
          Services::Notifications::Shifts::Create.call(shift)
        when :update
          Services::Notifications::Shifts::Update.call(shift, user_is, user_was)
        when :destroy
          Services::Notifications::Shifts::Destroy.call(shift)
      end
    end

    attr_reader :shift,
                :action,
                :user_is,
                :user_was

    protected :shift,
              :action,
              :user_is,
              :user_was
  end
end