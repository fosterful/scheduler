class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.text :message, null: false
      t.references :author, null: false, foreign_key: { to_table: users }
      t.bigint :user_ids, null: false, array: true, default: []

      

      t.timestamps
    end
  end
end
