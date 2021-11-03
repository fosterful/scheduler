class ShiftSurveyPolicy < ApplicationPolicy
  def permitted_attributes
    [:notes, :shift_id, :survey_id, :status]
  end
end