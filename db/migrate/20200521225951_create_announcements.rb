class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.text :message
      t.references :author, null: false, foreign_key: true
      t.bigint :user_ids, array: true, default: []

      

      t.timestamps
    end
  end
end
