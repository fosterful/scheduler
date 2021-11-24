class CreateShiftSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_surveys do |t|
      t.text :notes
      t.integer :status
      t.references :shift, null: false, foreign_key: true
      t.timestamps
    end
  end
end
