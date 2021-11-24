# frozen_string_literal: true

class ShiftSurveyWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform 
    send_shift_surveys
  end

  private
 
  def send_shift_surveys

    Need.where('start_at BETWEEN ? AND ? ', 1.day.ago, 30.minutes.ago).each do |need|
      need.shifts.pluck(:user_id).uniq.each do |user_id|
        user = User.find(user_id)
        remaining_shifts = need.shifts.where(user_id: user_id).where('start_at > ? ', Time.now - 30.minutes)
        if remaining_shifts.none?
          survey = ShiftSurvey.create!(need: need, user: user)
          message = "Thanks for taking a shift at the child welfare office today! We’d love to know how you’re feeling about it, or if there’s anything that needs our attention. Please take this one-minute survey. #{ shift_survey_path(survey) }"
          send_message(user, message)
        end
      end
    end
  end
  
  def send_message(user, message)
    Services::TextMessageEnqueue.send_messages([user.phone], message) if user.receive_sms_notifications?
    Services::EmailMessageEnqueue.send_messages([user.email], message) if user.receive_email_notifications?
  end

end
