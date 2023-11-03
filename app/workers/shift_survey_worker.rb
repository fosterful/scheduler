# frozen_string_literal: true

class ShiftSurveyWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform
    Shift.for_survey_notification.each do |shift|
      survey = ShiftSurvey.create!(need: shift.need, user: shift.user)
      message = "Thanks for taking a shift at the child welfare office today! We’d love to know how you’re feeling about it, or if there’s anything that needs our attention. Please take this one-minute survey. #{edit_shift_survey_url(survey)}"
      send_message(shift.user, message)
    end
  end

  private

  def send_message(user, message)
    if user.receive_sms_notifications?
      Services::TextMessageEnqueue.send_messages([user.phone],
                                                 message)
    end
    return unless user.receive_email_notifications?

    Services::EmailMessageEnqueue.send_messages([user.email],
                                                message)
  end
end
