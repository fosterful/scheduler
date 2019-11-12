class CreateOptouts < ActiveRecord::Migration[6.0]
  def change
    create_table :optouts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :need, null: false, foreign_key: true

      t.timestamps
    end
    add_index :optouts, [:user_id, :need_id], unique: true
  end
end
