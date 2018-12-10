class Office < ApplicationRecord
  has_one :address, as: :addressable
  validates :name, :address, presence: true

  accepts_nested_attributes_for :address, update_only: true
end
