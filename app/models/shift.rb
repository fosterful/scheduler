class Shift < ApplicationRecord
  belongs_to :need
  belongs_to :user, optional: true

  validates :start_at, :duration, presence: true

  def end_at
    start_at.advance(minutes: duration)
  end
end
