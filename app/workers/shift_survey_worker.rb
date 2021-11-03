# frozen_string_literal: true

class ShiftSurveyWorker
  include Sidekiq::Worker

  def perform 
    send_shift_surveys
  end

  private
 
  def send_shift_surveys
    # Possible Refactor: Get final shift for need per user, send survey for that shift if completed
      # need.shifts.order(:start_at).group_by(&:user_id)
      
    # Shifts that do not have surveys sent in the past day
    shifts = Shift.where.not('exists (?)', ShiftSurvey.where('shift_surveys.shift_id = shifts.id'))
    .where('start_at > ?', 1.day.ago)
    shifts.each do |shift|
      # Get all shifts for user for the same need
      user_need_shifts = shift.user.shifts.where(need_id: shift.need_id)
      remaining_user_need_shifts = user_need_shifts.where('start_at > ?', shift.start_at).where('need_id = ?', shift.need_id)
      # Only send if there are no remaining_user_need_shifts and the shift has been over for at least 30 minutes
      if !remaining_user_need_shifts.any? && Time.now > shift.end_at + 30.minutes && shift.shift_survey_id == nil #check for existing survey
        survey = ShiftSurvey.create!(shift_id: shift.id)
        user_need_shifts.update_all(shift_survey_id: survey.id)
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