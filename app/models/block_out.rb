class BlockOut < ApplicationRecord
  belongs_to :user

  has_many :recurrences, class_name: 'BlockOut', foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  belongs_to :parent, class_name: 'BlockOut', inverse_of: :recurrences, required: false

  scope :recurrences, -> { joins(:recurrences) }

  validates :start_at, :end_at,
            presence: true
  validates :start_at,
            inclusion: { in: ->(block_out) { (Date.today..) }, message: 'must be in the future' },
            if: :start_at_changed?

  validates :end_at,
            inclusion: { in: ->(block_out) { (block_out.start_at..) }, message: 'must be beyond start at' },
            if: :end_at_changed?,
            unless: -> { start_at.nil? }

  validates :last_recurrence, presence: true, if: :rrule?

  def duration_in_seconds
    end_at - start_at
  end
end
