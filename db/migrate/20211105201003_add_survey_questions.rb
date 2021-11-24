class AddSurveyQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :shift_surveys, :supplies, :text
    add_column :shift_surveys, :response_time, :text
    add_column :shift_surveys, :hours_match, :text
    add_column :shift_surveys, :ratings, :text
    add_column :shift_surveys, :ratings_text, :text
    add_column :shift_surveys, :comments, :text
    add_column :shift_surveys, :questions, :text
  end
end
