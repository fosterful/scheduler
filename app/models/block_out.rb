class BlockOut < ApplicationRecord
  belongs_to :user
  validates :start_at, presence: true
end
