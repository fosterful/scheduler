# frozen_string_literal: true

class Office < ApplicationRecord
  has_one :address, as: :addressable
  has_and_belongs_to_many :users
  has_many :needs, dependent: :destroy
  validates :name, :address, presence: true
  validates :region, numericality: { only_integer: true }

  accepts_nested_attributes_for :address, update_only: true

  scope :volunteer_minutes, -> { joins(needs: :shifts).merge(Shift.claimed) }
  scope :volunteer_minutes_by_office, -> { volunteer_minutes.group('offices.id') }
  scope :volunteer_minutes_by_state, -> { volunteer_minutes.joins(:address).group('addresses.state') }
  scope :volunteer_minutes_by_county, ->(state) { volunteer_minutes.joins(:address).where(addresses: { state: state }).group('addresses.county') }
  scope :children_served, -> { joins(:needs).merge(Need.has_claimed_shifts).reorder(nil).group('offices.id').sum('needs.number_of_children') }
  scope :children_served_by_state, -> { joins(:address, :needs).merge(Need.has_claimed_shifts).reorder(nil).group('addresses.state').sum('needs.number_of_children') }
  # scope :children_served_by_county, ->(state) { joins(:address, :needs).merge(Need.has_claimed_shifts).reorder(nil).where(addresses: { state: state }).group('addresses.county')}
  # scope :children_by_demographic, -> { joins(needs: :preferred_language).group('offices.id, languages.name').count('languages.name') }
  # scope :volunteers_by_demographic, -> { joins(users: :race).group('races.name').count('users.id') }

  def self.total_volunteer_minutes_by_office
    volunteer_minutes_by_office.sum('shifts.duration')
  end

  def self.total_volunteer_minutes_by_state
    volunteer_minutes_by_state.sum('shifts.duration')
  end

  def self.total_volunteer_minutes_by_county(state)
    volunteer_minutes_by_county(state).sum('shifts.duration')
  end
end
