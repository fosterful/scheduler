class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :street, :city, :state, :postal_code, presence: true
  validates_address geocode: true, fields: %i[street street2 city state postal_code]
end
