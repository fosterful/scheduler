class BlockOut < ApplicationRecord
  belongs_to :user
  validates :start_at,
            presence: true
  validates :start_at,
            inclusion: { in: ->(date) { (Date.today..) }, message: 'must be in the future' },
            if: :start_at_changed?
  validates :end_at,
            inclusion: { in: ->(date) { (Date.today..) }, message: 'must be in the future' },
            if: :end_at?
end
