class RemindWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform
    needs = Need.joins(:shifts).
      where("shifts.created_at < ?", 1.hour.ago).
      where("shifts.start_at > ?", Time.now).
      where("shifts.user_id IS NULL").distinct
    needs.each do |need|
      # Only send one message a day until within the day of
      if need.created_at < 12.hours.ago &&
        need.effective_start_at > 12.hours.from_now
        next unless Time.current.hour == 12
      end
      recipients = need.users_pending_response
      if recipients.any?
        phone_numbers = recipients.map(&:phone)
        message = "A need still has available shifts #{need_url(need)}"
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)
      end
    end
  end
end
