class Blockout < ApplicationRecord
  belongs_to :user

  has_many :occurrences, class_name: 'Blockout', foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  belongs_to :parent, class_name: 'Blockout', inverse_of: :occurrences, required: false

  validates :start_at, :end_at,
            presence: true
  validates :start_at,
            inclusion: { in: ->(blockout) { (Time.zone.now.beginning_of_day..) }, message: 'must be in the future' },
            if: :start_at_changed?

  validates :end_at,
            inclusion: { in: ->(blockout) { (blockout.start_at..) }, message: 'must be beyond start at' },
            if: :end_at_changed?,
            unless: -> { start_at.nil? }

  validates :last_occurrence, presence: true, if: :rrule?

  scope :occurrences, -> { joins(:parent) }
  scope :excluding_occurrences, -> { where(parent_id: nil) }
  scope :current, -> { where('start_at < ? AND last_occurrence > ?', 15.days.from_now.end_of_day, Time.zone.now.beginning_of_day) }
  scope :recurring, -> { current.where.not(rrule: nil) }
  scope :current_recurring, -> { current.merge(recurring) }

  def duration_in_seconds
    end_at - start_at
  end
end
