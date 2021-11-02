class ShiftSurvey < ApplicationRecord
  belongs_to :shift

private
  def self.generate_survey_token
    shift = self.shift
    token_a = [shift.user_id, shift.need_id, shift.id]
    token_string = token_a.join("-")
    return Base64.encode64(token_string)
  end
end