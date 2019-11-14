class Optout < ApplicationRecord
  belongs_to :user
  belongs_to :need

  validates :need_id, uniqueness: { scope: :user_id }

  before_create :init_shift_times

  def active?
    persisted? &&
    start_at <= need.effective_start_at && end_at >= need.effective_end_at
  end

  def update_shift_times
    update(
      start_at: [start_at, need.effective_start_at].min,
      end_at: [end_at, need.effective_end_at].max,
      occurrences: occurrences + 1
    )
  end

  private

  def init_shift_times
    self.start_at = need.effective_start_at
    self.end_at = need.effective_end_at
  end

end
