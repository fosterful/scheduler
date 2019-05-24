# frozen_string_literal: true

class SendTextMessageWorker
  include Sidekiq::Worker

  def perform(number, message)
    # TODO: remove guard clause
    # once notification refactor
    # is complete & all production
    # phone numbers are valid.
    return if TelephoneNumber.invalid?(number, :US, %i(mobile))

    if Rails.env.production?
      $twilio.api.account.messages.create(messaging_service_sid: Rails.configuration.twilio_messaging_service_sid, to: number, body: message)
    else
      $twilio.api.account.messages.create(from: Rails.configuration.twilio_number, to: number, body: message)
    end
  end
end
