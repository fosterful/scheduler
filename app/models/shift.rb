# frozen_string_literal: true

class Shift < ApplicationRecord
  default_scope { order(:start_at) }
  belongs_to :need, inverse_of: :shifts
  belongs_to :user, optional: true
  before_destroy :notify_user_of_cancelation, if: -> { user.present? }
  validates :start_at, :duration, presence: true

  scope :claimed, -> { where.not(user_id: nil).reorder(nil) }

  def end_at
    start_at.advance(minutes: duration)
  end

  def expired?
    end_at <= Time.zone.now
  end

  def notify_user_of_cancelation(user_to_notify = user)
    time = start_at.in_time_zone(user_to_notify.time_zone).to_s(:short_with_time)
    SendTextMessageWorker.perform_async(user_to_notify.phone, "Your shift on #{time} has been canceled.")
  end

  def can_destroy?
    return true if need.shifts.count > 1
    errors.add(:need, :remove_last_shift) && false
  end
end
