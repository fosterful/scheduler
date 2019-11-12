class Optout < ApplicationRecord
  belongs_to :user
  belongs_to :need

  validates :need_id, uniqueness: { scope: :user_id }
end
