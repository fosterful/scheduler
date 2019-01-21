class Race < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  validates :name, presence: true
end
