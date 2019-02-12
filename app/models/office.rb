# frozen_string_literal: true

class Office < ApplicationRecord
  has_one :address, as: :addressable
  has_and_belongs_to_many :users
  has_many :needs, dependent: :destroy
  validates :name, :address, presence: true
  validates :region, numericality: { only_integer: true }

  accepts_nested_attributes_for :address, update_only: true

  scope :total_volunteer_minutes, -> { joins(needs: :shifts).group('offices.id').sum('shifts.duration') }
  scope :total_volunteer_minutes_by_state, -> { joins(:address).joins(needs: :shifts).group('offices.id, addresses.state').sum('shifts.duration') }
  scope :total_volunteer_minutes_by_county, ->(state) { joins(:address).joins(needs: :shifts).where('addresses.state = ?', state).group('offices.id, addresses.county').sum('shifts.duration') }
end
