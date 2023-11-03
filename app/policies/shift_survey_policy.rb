# frozen_string_literal: true

class ShiftSurveyPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :notes,
      :need_id,
      :user_id,
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
      { ratings: [] }
    ]
  end
end
