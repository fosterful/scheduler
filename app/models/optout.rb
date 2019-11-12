class Optout < ApplicationRecord
  belongs_to :user
  belongs_to :need
end
