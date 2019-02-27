# frozen_string_literal: true

class SendTextMessageWorker
  include Sidekiq::Worker

  def perform(number, message)
    $twilio.api.account.messages.create(from: Rails.configuration.twilio_number, to: number, body: message)
  end
end
