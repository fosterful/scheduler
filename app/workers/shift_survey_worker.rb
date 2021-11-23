# frozen_string_literal: true

class ShiftSurveyWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform 
    send_shift_surveys
  end

  private
 
  def send_shift_surveys
    # Shifts that do not have surveys sent in the past day
    shifts = Shift.where.not('exists (?)', ShiftSurvey.where('shift_surveys.shift_id = shifts.id'))
    .where('start_at > ?', 1.day.ago)
    shifts.each do |shift|
      # Get all shifts for user for the same need
      user_need_shifts = shift.user.shifts.where(need_id: shift.need_id)
      remaining_user_need_shifts = user_need_shifts.where('start_at > ?', shift.start_at)
      # Only send if there are no remaining_user_need_shifts and the shift has been over for at least 30 minutes
      if !remaining_user_need_shifts.any? && Time.now > shift.end_at + 30.minutes && !shift.shift_survey.present? #check for existing survey
        survey = ShiftSurvey.create!(shift_id: shift.id)
        message = "Thanks for taking a shift at the child welfare office today! We’d love to know how you’re feeling about it, or if there’s anything that needs our attention. Please take this one-minute survey. #{ shift_survey_path(survey) }"
        send_message(shift.user, message)
      end
    end
  end
  
  def send_message(user, message)
    Services::TextMessageEnqueue.send_messages([user.phone], message) if user.receive_sms_notifications?
    Services::EmailMessageEnqueue.send_messages([user.email], message) if user.receive_email_notifications?
  end

end