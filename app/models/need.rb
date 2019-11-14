# frozen_string_literal: true

class Need < ApplicationRecord
  include NotificationConcern

  belongs_to :office
  belongs_to :user
  belongs_to :race, optional: true
  belongs_to :preferred_language,
             class_name: 'Language'
  has_and_belongs_to_many :age_ranges
  has_many :shifts, dependent: :destroy
  has_many :users, through: :shifts
  has_many :optouts

  validates :age_ranges,
            :start_at,
            :expected_duration,
            :number_of_children,
            :office,
            presence: true
  validates :expected_duration,
            numericality: { greater_than_or_equal_to: 60,
                            message:                  'must be at least one hour' }

  scope :current, lambda {
    where('start_at > ?', Time.zone.now.at_beginning_of_day)
      .order(start_at: :asc)
  }
  scope :has_claimed_shifts, lambda {
    where('EXISTS(SELECT 1 FROM shifts WHERE shifts.need_id = needs.id '\
            'AND shifts.user_id IS NOT NULL)')
  }

  def self.total_children_served
    has_claimed_shifts.sum(:number_of_children)
  end

  alias_attribute :duration, :expected_duration

  def end_at
    start_at.advance(minutes: expected_duration)
  end

  def expired?
    end_at <= Time.zone.now
  end

  def effective_start_at
    [start_at, *shifts.pluck(:start_at)].min
  end

  def effective_end_at
    last_shift = shifts.order(:start_at).last
    if last_shift.nil?
      end_at
    else
      [end_at, last_shift.end_at].max
    end
  end

  def notification_candidates
    office
      .notifiable_users
      .where.not(id: notified_user_ids | [user_id])
  end

  def users_to_notify
    notification_candidates
      .exclude_blockouts(start_at, end_at)
      .exclude_optouts(self)
      .then { |users| scope_users_by_language(users) }
      .then { |users| scope_users_by_age_ranges(users) }
  end

  def users_pending_response
    User.where(id: notified_user_ids).exclude_optouts(self).
      where.not(id: user_ids)
  end

  def active_optouts
    optouts.where("start_at <= ?", effective_start_at).
    where("end_at >= ?", effective_end_at)
  end
end
