# frozen_string_literal: true

class ShiftSurveyWorker
  include Sidekiq::Worker

  def perform 
    send_shift_surveys
  end

  private
 
  def send_shift_surveys
    # Shifts that do not have surveys sent in the past day
    shifts = Shift.where.not('exists (?)', ShiftSurvey.where('shift_surveys.shift_id = shifts.id'))
      .where('start_at > ?', 1.day.ago)
    shifts.each do |shift|
      # Only send if there are no more shifts for the need for the user
      user_shifts = shift.user.shifts.where(need_id: shift.need_id)
      remaining_shifts = user_shifts
        .where('start_at > ?', shift.start_at)
        .where('need_id = ?', shift.need_id)
      if !remaining_shifts.any? && Time.now > shift.end_at + 30.minutes && shift.shift_survey_id == nil
        survey = ShiftSurvey.create!(shift_id: shift.id)
        user_shifts.update_all(shift_survey_id: survey.id)
        message = "Test Message"
        send_message(shift.user.email, message)
      end
    end
  end
  
  def send_message(email_address, message)
    #TODO: Determine and send preferred notification preference. 
    Services::EmailMessageEnqueue.send_messages(email_address, message)
  end

end