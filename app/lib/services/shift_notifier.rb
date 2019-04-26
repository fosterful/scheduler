# frozen_string_literal: true

module Services
  class ShiftNotifier

    def initialize(shift, action, current_user = nil, user_was = nil)
      self.shift        = shift
      self.action       = action
      self.current_user = current_user
      self.user_was     = user_was
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

      klass.new(shift, current_user, user_was).call
    end

    attr_accessor :action,
                  :current_user,
                  :shift,
                  :user_was

    protected :action,
              :current_user,
              :shift,
              :user_was
  end
end
