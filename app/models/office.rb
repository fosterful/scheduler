class Office < ApplicationRecord
  has_one :address, as: :addressable
  has_and_belongs_to_many :users
  validates :name, :address, presence: true

  accepts_nested_attributes_for :address, update_only: true
end
