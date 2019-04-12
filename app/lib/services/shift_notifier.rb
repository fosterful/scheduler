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
      klass = case action
                when :create
                  Services::Notifications::Shifts::Create
                when :update
                  Services::Notifications::Shifts::Update
                when :destroy
                  Services::Notifications::Shifts::Destroy
              end

      klass.call(shift, user_is, user_was)
    end

    attr_reader :action,
                :shift,
                :user_is,
                :user_was

    protected :action,
              :shift,
              :user_is,
              :user_was
  end
end
