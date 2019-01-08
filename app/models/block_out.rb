class BlockOut < ApplicationRecord
  belongs_to :user

  has_many :recurrences, class_name: 'BlockOut', foreign_key: :parent_id, inverse_of: :parent
  belongs_to :parent, class_name: 'BlockOut', inverse_of: :recurrences, required: false

  validates :start_at,
            presence: true
  validates :start_at,
            inclusion: { in: ->(date) { (Date.today..) }, message: 'must be in the future' },
            if: :start_at_changed?
  validates :end_at,
            inclusion: { in: ->(date) { (Date.today..) }, message: 'must be in the future' },
            if: :end_at?
end
