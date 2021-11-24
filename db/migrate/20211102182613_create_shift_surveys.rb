class CreateShiftSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_surveys do |t|
      t.text :notes
      t.string :status, :default => "Incomplete"
      t.string :token
      t.references :shift, null: false, foreign_key: true
      t.boolean :supplies
      t.text :supplies_text
      t.boolean :response_time
      t.text :response_time_text
      t.boolean :hours_match
      t.text :hours_match_text
      t.text :ratings
      t.text :ratings_text
      t.text :comments
      t.text :questions
      t.timestamps
    end
  end
end
