# frozen_string_literal: true

class Office < ApplicationRecord
  has_one :address, as: :addressable, dependent: :destroy
  has_many :needs, dependent: :destroy
  has_many :office_users, dependent: :destroy
  has_many :users, through: :office_users
  validates :name, :address, presence: true
  validates :region, numericality: { only_integer: true }

  accepts_nested_attributes_for :address, update_only: true

  alias_attribute :to_s, :name

  scope :with_claimed_shifts, -> { joins(needs: :shifts).merge(Shift.claimed) }
  scope :with_claimed_needs, -> { joins(:needs).merge(Need.has_claimed_shifts) }

  alias_attribute :to_s, :name

  def self.claimed_shifts_by_county(state)
    with_claimed_shifts
      .joins(:address)
      .where(addresses: { state: state })
      .group('addresses.county')
  end

  def self.claimed_needs_by_county(state)
    with_claimed_needs
      .joins(:address)
      .where(addresses: { state: state })
      .group('addresses.county')
  end

  def self.total_volunteer_hours_by_office(start_at, end_at)
    with_claimed_shifts
      .then { |scope| filter_by_date_range(scope, start_at, end_at) } 
      .group('offices.id')
      .sum('shifts.duration / 60.0')
  end

  def self.total_volunteer_hours_by_state(start_at, end_at)
    with_claimed_shifts
      .joins(:address)
      .group('addresses.state')
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .sum('shifts.duration / 60.0')
  end

  def self.total_volunteer_hours_by_county(state)
    claimed_shifts_by_county(state).sum('shifts.duration / 60.0')
  end

  def self.total_children_served_by_office(start_at, end_at)
    with_claimed_needs
      .group('offices.id')
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .sum('needs.number_of_children')
  end

  def self.total_children_served_by_state(start_at, end_at)
    with_claimed_needs
      .joins(:address)
      .group('addresses.state')
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .sum('needs.number_of_children')
  end

  def self.total_children_served_by_county(state)
    claimed_needs_by_county(state).sum('needs.number_of_children')
  end

  def self.total_children_by_demographic(start_at, end_at)
    joins(needs: :preferred_language)
      .group('languages.name')
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .sum('needs.number_of_children')
  end

  def self.total_volunteers_by_race(start_at, end_at)
    joins(:needs, users: :race)
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('races.name')
      .count('users.id')
  end

  def notifiable_users
    users.notifiable
  end

  private

  def self.parse_start_date(date)
    (date ? Date.parse(date) : DateTime.new(2000, 1, 1)).beginning_of_day
  end

  def self.parse_end_date(date)
    (date ? Date.parse(date) : DateTime.tomorrow).end_of_day
  end

  def self.filter_by_date_range(scope, start_at, end_at)
    scope.where('needs.start_at between ? AND ?', parse_start_date(start_at), parse_end_date(end_at))
  end
end
