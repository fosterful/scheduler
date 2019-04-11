# frozen_string_literal: true

module Services
  class TextMessageEnqueue
    include Concord.new(:phone_number, :message)
    include Procto.call

    def call
      SendTextMessageWorker.perform_async(phone_number, message)
    end
  end
end
