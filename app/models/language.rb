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
           inverse_of:  :second_language
  has_many :needs,
           dependent:   :restrict_with_error,
           foreign_key: :preferred_language_id,
           inverse_of:  :preferred_language

  validates :name, presence: true
end
