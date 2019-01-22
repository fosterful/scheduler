class Need < ApplicationRecord
  belongs_to :office
  belongs_to :user
  belongs_to :preferred_language, class_name: 'Language', optional: true
  has_and_belongs_to_many :age_ranges
  has_many :shifts, dependent: :destroy

  validates :start_at, :expected_duration, :number_of_children, presence: true
  validates :expected_duration, inclusion: { in: ->(need) { (60..) }, message: 'must be at least on hour' }

  alias_attribute :duration, :expected_duration

  def preferred_language
    super || NullLanguage.new
  end

  def end_at
    start_at.advance(minutes: expected_duration)
  end
end
