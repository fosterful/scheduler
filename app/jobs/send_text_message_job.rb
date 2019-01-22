# frozen_string_literal: true

class SendTextMessageJob < ApplicationJob
  queue_as :default

  def perform(number, message)
    # TODO: Make me send text messages :-)
    Rails.logger.info("Sending text to #{number}: #{message}")
  end
end
