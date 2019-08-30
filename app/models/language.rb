# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :primary_speakers,
           class_name:  'User',
           foreign_key: :first_language_id,
           dependent:   :restrict_with_error,
           inverse_of:  :first_language
  has_many :secondary_speakers,
           class_name:  'User',
           foreign_key: :second_language_id,
           dependent:   :restrict_with_error,
           inverse_of:  :second_langauge
  has_many :needs, dependent: :restrict_with_error

  validates :name, presence: true
end
