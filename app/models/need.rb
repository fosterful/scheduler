# frozen_string_literal: true

class Need < ApplicationRecord
  include NotificationConcern

  belongs_to :office
  belongs_to :user
  belongs_to :race, optional: true
  belongs_to :preferred_language,
             class_name: 'Language'
  has_and_belongs_to_many :age_ranges
  has_and_belongs_to_many :social_workers, class_name: 'User',
    join_table: 'needs_social_workers',
    association_foreign_key: 'social_worker_id'
  has_many :shifts, dependent: :destroy
  has_many :users, through: :shifts

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
  scope :on_date, lambda { |date|
    where('start_at between ? and ?', date.beginning_of_day, date.end_of_day)
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

  def notification_candidates
    office
      .notifiable_users
      .where.not(id: unavailable_user_ids | [user_id])
  end

  def users_to_notify
    notification_candidates
      .exclude_blockouts(start_at, end_at)
      .then { |users| scope_users_by_language(users) }
      .then { |users| scope_users_by_age_ranges(users) }
  end

  def unavailable_users
    User.find(unavailable_user_ids)
  end

  def users_pending_response
    User.find(notified_user_ids - unavailable_user_ids - shifts.pluck(:user_id))
  end
end
