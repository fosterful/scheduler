# frozen_string_literal: true

class SendTextMessageWorker
  include Sidekiq::Worker

  def perform(number, message)
    $twilio.api.account.messages.create(from: '+16309841220', to: number, body: message) if number
  end
end
