class AgeRange < ApplicationRecord
  validates :min, :max, presence: true, numericality: { only_integer: true }
end
