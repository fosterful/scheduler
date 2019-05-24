# frozen_string_literal: true

module Services
  class ShiftNotifier
    include Procto.call

    def initialize(shift, action, args = {})
      self.shift  = shift
      self.action = action
      self.args   = args
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

      klass.new(shift, args).call
    end

    private

    attr_accessor :action,
                  :args,
                  :shift
  end
end
