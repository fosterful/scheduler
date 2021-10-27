class Child < ApplicationRecord
  belongs_to :need
  enum sex: { male: 0, female: 1 }

  validates :age, 
            :sex, 
             presence: true
end