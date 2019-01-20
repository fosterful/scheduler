class Need < ApplicationRecord
  belongs_to :office
  belongs_to :user
  belongs_to :preferred_language, class_name: 'Language'
  has_and_belongs_to_many :age_ranges
  has_many :shifts

  validates :start_at, :expected_duration, :number_of_children, presence: true
  validates :expected_duration, inclusion: { in: ->(need) { (60..) }, message: 'must be at least on hour' }

  alias_attribute :duration, :expected_duration
end
