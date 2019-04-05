# frozen_string_literal: true

class Need < ApplicationRecord
  include NotificationConcern

  default_scope { order(:start_at) }

  belongs_to :office
  belongs_to :user
  belongs_to :race, optional: true
  belongs_to :preferred_language,
             class_name: 'Language',
             optional: true
  has_and_belongs_to_many :age_ranges
  has_many :shifts, dependent: :destroy
  has_many :users, through: :shifts

  validates :age_ranges,
            :start_at,
            :expected_duration,
            :number_of_children,
            presence: true
  validates :expected_duration,
            numericality: { greater_than_or_equal_to: 60,
                            message: 'must be at least one hour' }

  scope :current, -> { where('start_at > ?', Time.zone.now) }

  alias_attribute :duration, :expected_duration

  def preferred_language
    super || NullLanguage.new
  end

  def end_at
    start_at.advance(minutes: expected_duration)
  end

  def expired?
    end_at <= Time.zone.now
  end

  def effective_start_at
    [start_at, *shifts.pluck(:start_at)].min
  end

  def users_to_notify
    office
      .users
      .volunteerable
      .with_phone
      .where.not(id: notified_user_ids | [user_id])
      .available_within(shifts.first.start_at, shifts.last.end_at)
      .then { |users| scope_users_by_language(users) }
      .then { |users| scope_users_by_age_ranges(users) }
  end
end
