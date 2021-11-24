class ShiftSurveyPolicy < ApplicationPolicy
  def permitted_attributes
    [
    :notes,
    :shift_id,
    :survey_id,
    :status,
    :supplies,
    :response_time,
    :hours_match,
    :supplies_text,
    :response_time_text,
    :hours_match_text,
    :ratings_text,
    :comments,
    :questions,
    :ratings => []
    ]
  end
end