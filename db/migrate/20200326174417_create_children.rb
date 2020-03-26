class CreateChildren < ActiveRecord::Migration[6.0]
  def change
    create_table :children do |t|
      t.integer :age
      t.integer :sex
      t.text :notes
      t.string :name

      t.timestamps
    end
  end
end
