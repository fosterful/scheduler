# frozen_string_literal: true

module Services
  class TextMessageEnqueue
    include Concord.new(:phone_numbers, :message)
    include Procto.call

    def call
      phone_numbers.each do |phone_number|
        SendTextMessageWorker.perform_async(phone_number, message)
      end
    end
  end
end
