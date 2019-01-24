class CreateRaces < ActiveRecord::Migration[5.2]
  def change
    create_table :races do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
