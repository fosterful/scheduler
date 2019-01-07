class CreateAgeRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :age_ranges do |t|
      t.integer :min, null: false
      t.integer :max, null: false

      t.timestamps
    end
  end
end
