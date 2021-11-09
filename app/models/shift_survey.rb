class ShiftSurvey < ApplicationRecord
  belongs_to :shift
  after_create :generate_token
  serialize :ratings, Array

  def to_param
    token
  end

  def generate_token
    self.update(token: SecureRandom.urlsafe_base64(16))
  end
end