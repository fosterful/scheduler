# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :primary_speakers, class_name: 'User', foreign_key: :first_language_id, dependent: :restrict_with_error
  has_many :secondary_speakers, class_name: 'User', foreign_key: :second_language_id, dependent: :restrict_with_error
  has_many :needs
  validates :name, presence: true
end
