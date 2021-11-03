class ShiftSurvey < ApplicationRecord
  belongs_to :shift
  after_create :generate_survey_token

  def generate_survey_token
    shift = self.shift
    token_a = [shift.user_id, shift.need_id, shift.id]
    token_string = token_a.join("-")
    self.update(token: Base64.encode64(token_string))
  end
end