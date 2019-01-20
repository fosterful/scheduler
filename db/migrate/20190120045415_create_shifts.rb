class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.references :need, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :start_at, null: false
      t.integer :duration, null: false
      t.boolean :canceled, null: false, default: false

      t.timestamps
    end
  end
end
