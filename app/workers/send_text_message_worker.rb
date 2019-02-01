# frozen_string_literal: true

class SendTextMessageWorker
  include Sidekiq::Worker

  def perform(number, message)
    # TODO: Make me send text messages :-)
    Rails.logger.info("Sending text to #{number}: #{message}")
  end
end
