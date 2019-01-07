class AgeRange < ApplicationRecord
  validates :min, :max, presence: true, numericality: { only_integer: true }
  validate :min_less_or_equal_to_max

  def min_less_or_equal_to_max
    errors.add(:base, 'Minimum age must be less than or equal to max age') if min.to_i > max.to_i
  end
end
