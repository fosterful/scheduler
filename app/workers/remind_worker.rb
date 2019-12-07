class RemindWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform
    send_daily_messages
    send_hourly_messages
  end

  def send_daily_messages
    if Time.current.hour == 12 # only send at noon
      needs = Need.joins(:shifts).
        where("shifts.start_at > ?", 12.hours.from_now).
        where("needs.created_at < ?", 12.hours.ago).
        where("shifts.user_id IS NULL").distinct
      send_messages(needs)
    end
  end

  def send_hourly_messages
    needs = Need.joins(:shifts).
      where("shifts.created_at BETWEEN ? AND ?", 12.hours.ago, 1.hour.ago).
      where("shifts.start_at BETWEEN ? AND ?", Time.now, 12.hours.from_now).
      where("shifts.user_id IS NULL").distinct
    send_messages(needs)
  end

  def send_messages(needs)
    needs.each do |need|
      recipients = need.users_pending_response
      if recipients.any?
        phone_numbers = recipients.map(&:phone)
        message = "A need still has available shifts #{need_url(need)}"
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)
      end
    end
  end
end
