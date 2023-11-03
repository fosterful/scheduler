# frozen_string_literal: true

class ShiftSurvey < ApplicationRecord
  extend DateRangeFilterHelper

  belongs_to :user
  belongs_to :need
  after_create :generate_token

  def to_param
    token
  end

  def generate_token
    update(token: SecureRandom.urlsafe_base64(16))
  end

end
