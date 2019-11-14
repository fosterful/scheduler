class Optout < ApplicationRecord
  belongs_to :user
  belongs_to :need

  validates :need_id, uniqueness: { scope: :user_id }

  before_create :init_start_and_end_at
  before_update :update_start_and_end_at
  before_update :increment_occurrences

  def active?
    start_at <= need.effective_start_at && end_at >= need.effective_end_at
  end

  private

  def init_start_and_end_at
    self.start_at = need.effective_start_at
    self.end_at = need.effective_end_at
  end

  def update_start_and_end_at
    self.start_at = [start_at, need.effective_start_at].min
    self.end_at = [end_at, need.effective_end_at].max
  end

  def increment_occurrences
    increment! :occurrences
  end
end
