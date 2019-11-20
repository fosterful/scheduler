# frozen_string_literal: true

class Shift < ApplicationRecord
  include NotificationConcern

  belongs_to :need, inverse_of: :shifts
  has_one :office, through: :need
  has_one :preferred_language, through: :need
  belongs_to :user, optional: true
  before_destroy :notify_user_of_cancelation,
                 if: -> { user&.phone.present? }
  after_create :clear_unavailable_users
  after_update :make_user_available

  validates :duration,
            :start_at,
            presence: true

  delegate :age_range_ids,
           :age_ranges,
           :notification_candidates,
           :preferred_language,
           to: :need

  def duration_in_words
    "#{start_at.to_s(:time)} to #{end_at.to_s(:time)}"
  end

  scope :claimed, -> { where.not(user_id: nil) }

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
      .send_messages([recipient.phone],
                     "Your shift on #{time} has been canceled.")
  end

  def users_to_notify
    # this differs from Need#users_to_notify because start_at and end_at differ
    notification_candidates
      .exclude_blockouts(start_at, end_at)
      .then { |users| scope_users_by_language(users) }
      .then { |users| scope_users_by_age_ranges(users) }
  end

  def can_destroy?
    return true if need.shifts.many?

    errors.add(:need, :remove_last_shift) && false
  end

  private

  def clear_unavailable_users
    need.update! unavailable_user_ids: []
  end

  def make_user_available
    if need.unavailable_user_ids.include?(user_id)
      need.unavailable_user_ids -= [user_id]
      need.save!
    end
  end
end
