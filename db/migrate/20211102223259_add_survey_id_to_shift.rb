class AddSurveyIdToShift < ActiveRecord::Migration[6.1]
  def change
    add_reference :shifts, :shift_survey, index: true
  end
end
