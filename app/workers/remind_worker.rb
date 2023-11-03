# frozen_string_literal: true

class RemindWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform
    send_daily_messages
    send_hourly_messages
  end

  private

  def send_daily_messages
    return unless Time.current.hour == 12 # only send at noon

    needs = Need.joins(:shifts)
      .where('shifts.start_at > ?', 12.hours.from_now)
      .where('needs.created_at < ?', 12.hours.ago)
      .where(shifts: { user_id: nil }).distinct
    send_messages(needs)
  end

  def send_hourly_messages
    needs = Need.joins(:shifts)
      .where('shifts.created_at BETWEEN ? AND ?', 12.hours.ago, 1.hour.ago)
      .where('shifts.start_at BETWEEN ? AND ?', Time.zone.now, 12.hours.from_now)
      .where(shifts: { user_id: nil }).distinct
    send_messages(needs)
  end

  def send_messages(needs)
    needs.each do |need|
      recipients = need.users_pending_response
      next unless recipients.any?

      phone_numbers = recipients.map(&:phone)
      message = "A need still has available shifts #{need_url(need)}"
      Services::TextMessageEnqueue.send_messages(phone_numbers, message)
    end
  end
end
