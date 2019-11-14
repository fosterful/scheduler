class AddOptoutUpdating < ActiveRecord::Migration[6.0]
  def change
    change_table :optouts do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :occurrences, default: 1
    end
  end
end
