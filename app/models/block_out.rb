class BlockOut < ApplicationRecord
  belongs_to :user
  validates :start_at,
            presence: true,
            inclusion: { in: ->(date) { (Date.today..) }, message: 'must be in the future' }
end
