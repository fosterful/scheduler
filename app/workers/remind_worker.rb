class RemindWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(need_id)
    need = Need.find(need_id)
    recipients = need.users_pending_response
    message = "A need still has available shifts #{need_url(need)}"
    if need.has_available_shifts?
      if recipients.any?
        phone_numbers = recipients.map(&:phone)
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)
      end
      RemindWorker.perform_async(RemindWorker.next_queue_time, need.id)
    end
  end

  def self.next_queue_time
    # Only message people between 9am and 8pm Pacific
    queue_time = 1.hour.from_now
    if queue_time.hour < 9
      Date.current.beginning_of_day + 9.hours
    elsif queue_time.hour > 20
      Date.current.tomorrow.beginning_of_day + 9.hours
    else
      queue_time
    end
  end
end
