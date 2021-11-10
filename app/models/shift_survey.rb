class ShiftSurvey < ApplicationRecord
  extend DateRangeFilterHelper

  belongs_to :shift
  after_create :generate_token
  serialize :ratings, Array

  # scope :complete_surveys, lambda { |survey|
  #   where(survey.status === "Complete")
  # }

  def self.survey_responses_by_shift(current_user, start_at, end_at)
    ShiftSurvey.joins(:shift)
    .where('shifts.start_at between ? AND ?', parse_start_date(start_at), parse_end_date(end_at))
  end

  def generate_token
    self.update(token: SecureRandom.urlsafe_base64(16))
  end

  
end
