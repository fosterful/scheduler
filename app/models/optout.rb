class Optout < ApplicationRecord
  belongs_to :user
  belongs_to :need

  validates :need_id, uniqueness: { scope: :user_id }

  before_create :init_start_and_end_at
  before_update :update_start_and_end_at
  before_update :increment_occurrences

  private

  def init_start_and_end_at
    self.start_at = need.start_at
    self.end_at = need.end_at
  end

  def update_start_and_end_at
    self.start_at = [start_at, need.start_at].min
    self.end_at = [end_at, need.end_at].max
  end

  def increment_occurrences
    self.occurrences.increment!
  end
end
