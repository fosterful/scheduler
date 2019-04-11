# frozen_string_literal: true

class Shift < ApplicationRecord

  default_scope { order(:start_at) }

  belongs_to :need
  has_one :office, through: :need
  has_one :preferred_language, through: :need
  belongs_to :user, optional: true
  before_destroy :notify_user_of_cancelation,
                 if: -> { user&.phone.present? }

  validates :duration,
            :start_at,
            presence: true

  def end_at
    start_at.advance(minutes: duration)
  end

  def expired?
    end_at <= Time.zone.now
  end

  def notify_user_of_cancelation(recipient = user)
    time = start_at
             .in_time_zone(recipient.time_zone)
             .to_s(:short_with_time)

    Services::TextMessageEnqueue
      .call(recipient.phone, "Your shift on #{time} has been canceled.")
  end

  def users_to_notify
    need
      .notification_candidates
      .available_within(start_at, end_at)
      .then { |users| scope_users_by_language(users) }
      .then { |users| scope_users_by_age_ranges(users) }
  end
end
