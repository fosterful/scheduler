class ShiftSurveyPolicy < ApplicationPolicy
  def permitted_attributes
    [:notes, :shift_id, :survey_id, :status, :supplies, :response_time, :hours_match, :ratings, :ratings_text, :comments, :questions]
  end
end