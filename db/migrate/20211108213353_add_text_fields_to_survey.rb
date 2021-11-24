class AddTextFieldsToSurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :shift_surveys, :supplies_text, :text
    add_column :shift_surveys, :response_time_text, :text
    add_column :shift_surveys, :hours_match_text, :text

    change_column :shift_surveys, :supplies, 'boolean USING CAST(supplies AS boolean)'
    change_column :shift_surveys, :response_time, 'boolean USING CAST(response_time AS boolean)'
    change_column :shift_surveys, :hours_match, 'boolean USING CAST(hours_match AS boolean)'
  end
end