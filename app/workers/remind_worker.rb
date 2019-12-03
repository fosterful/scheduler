class RemindWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform
    needs = Need.joins(:shifts).where("shifts.created_at < ?", 1.hour.ago).
      where("shifts.start_at > ?", Time.now).distinct
    needs.each do |need|
      recipients = need.users_pending_response
      message = "A need still has available shifts #{need_url(need)}"
      if recipients.any? && need.has_available_shifts?
        phone_numbers = recipients.map(&:phone)
        Services::TextMessageEnqueue.send_messages(phone_numbers, message)
      end
    end
  end
end

Sidekiq::Cron::Job.create(
  name: 'Reminders', cron: '0 9-20 * * *', class: 'RemindWorker'
)
