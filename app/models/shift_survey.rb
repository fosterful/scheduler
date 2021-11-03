class ShiftSurvey < ApplicationRecord
  belongs_to :shift
  after_create :generate_token

  def generate_token
    shift = self.shift
    token_a = [shift.user_id, shift.need_id, shift.id]
    token_string = token_a.join("-")
    self.update(token: Base64.urlsafe_encode64(token_string))
  end
end