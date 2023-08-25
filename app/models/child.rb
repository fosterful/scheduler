class Child < ApplicationRecord
  belongs_to :need
  enum sex: { male: 0, female: 1, non_binary: 2 }

  validates :age,
            :sex,
            presence: true
end