# frozen_string_literal: true

class Office < ApplicationRecord
  has_one :address, as: :addressable
  has_and_belongs_to_many :users
  has_many :needs, dependent: :destroy
  validates :name, :address, presence: true
  validates :region, numericality: { only_integer: true }

  accepts_nested_attributes_for :address, update_only: true

  scope :volunteer_minutes, -> { joins(needs: :shifts).group('offices.id').sum('shifts.duration') }
  scope :volunteer_minutes_by_state, -> { joins(:address).joins(needs: :shifts).group('addresses.state').sum('shifts.duration') }
  scope :volunteer_minutes_by_county, ->(state) { joins(:address).joins(needs: :shifts).where('addresses.state = ?', state).group('offices.id, addresses.county').sum('shifts.duration') }
  scope :children_served, -> { joins(needs: :shifts).where.not(shifts: { user_id: nil }).group('offices.id').sum('needs.number_of_children') }
  scope :children_served_by_state, -> { joins(:address).joins(:needs).group('offices.id, addresses.state').sum('needs.number_of_children')}
  scope :children_served_by_county, ->(state) { joins(:address).joins(:needs).where('addresses.state= ?', state).group('offices.id, addresses.county').sum('needs.number_of_children')}
  scope :children_by_demographic, -> { joins(needs: :preferred_language).group('offices.id, languages.name').count('needs.id') }
  scope :volunteers_by_demographic, -> { joins(users: :race).group('races.name').count('users.id') }
end
