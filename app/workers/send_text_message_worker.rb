# frozen_string_literal: true

class SendTextMessageWorker
  include Sidekiq::Worker

  def perform(number, message)
    $twilio.api.account.messages.create(from: '+15005550006', to: number, body: message)
  end
end
