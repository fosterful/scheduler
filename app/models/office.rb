# frozen_string_literal: true

class Office < ApplicationRecord
  has_one :address, as: :addressable
  has_and_belongs_to_many :users
  has_many :needs, dependent: :destroy
  validates :name, :address, presence: true
  validates :region, numericality: { only_integer: true }

  accepts_nested_attributes_for :address, update_only: true

  scope :with_claimed_shifts, -> { joins(needs: :shifts).merge(Shift.claimed) }
  scope :with_claimed_needs, -> { joins(:needs).merge(Need.has_claimed_shifts) }

  def self.claimed_shifts_by_office
    with_claimed_shifts.group('offices.id')
  end

  def self.claimed_shifts_by_state
    with_claimed_shifts.joins(:address).group('addresses.state')
  end

  def self.claimed_shifts_by_county(state)
    with_claimed_shifts.joins(:address).where(addresses: { state: state }).group('addresses.county')
  end

  def self.claimed_needs_by_office
    with_claimed_needs.group('offices.id')
  end

  def self.claimed_needs_by_state
    with_claimed_needs.joins(:address).group('addresses.state')
  end

  def self.claimed_needs_by_county(state)
    with_claimed_needs.joins(:address).where(addresses: { state: state }).group('addresses.county')
  end

  def self.with_preferred_language
    joins(needs: :preferred_language).group('languages.name')
  end

  def self.users_by_race
    joins(users: :race).group('races.name')
  end

  def self.total_volunteer_minutes_by_office
    claimed_shifts_by_office.sum('shifts.duration')
  end

  def self.total_volunteer_minutes_by_state
    claimed_shifts_by_state.sum('shifts.duration')
  end

  def self.total_volunteer_minutes_by_county(state)
    claimed_shifts_by_county(state).sum('shifts.duration')
  end

  def self.total_children_served_by_office
    claimed_needs_by_office.sum('needs.number_of_children')
  end

  def self.total_children_served_by_state
    claimed_needs_by_state.sum('needs.number_of_children')
  end

  def self.total_children_served_by_county(state)
    claimed_needs_by_county(state).sum('needs.number_of_children')
  end

  def self.total_children_by_demographic
    with_preferred_language.sum('needs.number_of_children')
  end

  def self.total_volunteers_by_race
    users_by_race.count('users.id')
  end

  def notifiable_users
    users.notifiable
  end

end
