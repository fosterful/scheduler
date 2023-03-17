# frozen_string_literal: true

class SendTextMessageWorker
  include Sidekiq::Worker

  TWILIO_SID    = Rails.configuration.try(:twilio_messaging_service_sid)
  TWILIO_NUMBER = Rails.configuration.try(:twilio_number)

  def perform(number, message)
    # TODO: remove guard clause
    # once notification refactor
    # is complete & all production
    # phone numbers are valid.
    return if TelephoneNumber.invalid?(number, :US, %i(mobile))

    params = if Rails.env.production?
               { messaging_service_sid: TWILIO_SID }
             else
               { from: TWILIO_NUMBER }
             end.merge(to: number, body: message)

    $twilio.api.account.messages.create(**params)
  end
end
