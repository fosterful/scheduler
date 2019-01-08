class CreateBlockOuts < ActiveRecord::Migration[5.2]
  def change
    create_table :block_outs do |t|
      t.references :user, foreign_key: true, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.text :rrule
      t.text :reason

      t.timestamps
    end
  end
end
