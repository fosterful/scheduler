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
  
  validate :covid_19_status, on: :update

  delegate :age_range_ids,
           :age_ranges,
           :notification_candidates,
           :preferred_language,
           to: :need

  def self.for_survey_notification
    # Find last shift for a given user & need
    # Having clause is to window results so as to keep
    # query performant
    subquery = select(:user_id, :need_id, "MAX(start_at) AS max_start_at")
                .having('MAX(start_at) BETWEEN ? AND ?', 2.day.ago, Time.current)
                .group(:user_id, :need_id)

    # Get whole records based on subquery above
    join_sql = <<~SQL
      INNER JOIN (#{subquery.to_sql}) sub ON (
        sub.user_id = shifts.user_id
        AND sub.need_id = shifts.need_id
        AND sub.max_start_at = shifts.start_at
      )
    SQL

    # Add additional filtering for users that have alread been sent the survey
    # and where the shift end is greater than 30 minutes ago
    joins(join_sql)
      .where('start_at + make_interval(mins := duration) < ?', 30.minutes.ago)
      .joins('LEFT JOIN shift_surveys on (shift_surveys.need_id = shifts.need_id AND shift_surveys.user_id = shifts.user_id)')
      .where('shift_surveys.id IS NULL')
  end

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

  def user_need_shifts
    if user_id?
      user.shifts.where(need_id: need_id)
    end
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
    return unless need.unavailable_user_ids.include?(user_id)

    need.unavailable_user_ids -= [user_id]
    need.save!
  end

  def covid_19_status
    # Verify that a user is being assigned to the shift
    return true unless user.present? && user_id_changed? && user_id_was.nil?

    # Only validate if user requires covid 19 vaccination
    return true unless user.require_covid_19_vaccinated?

    # If the user has been vaccinated, return.
    return true if user&.covid_19_vaccinated?

    errors.add(:base, "#{user} has not reported their COVID-19 vaccination status and cannot be assigned to this shift.") && false
  end
end
