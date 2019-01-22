# frozen_string_literal: true

class CreateNeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :needs do |t|
      t.references :office, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :preferred_language, foreign_key: { to_table: :languages }
      t.datetime :start_at, null: false
      t.integer :expected_duration, null: false
      t.integer :number_of_children, null: false
      t.bigint :notified_user_ids, array: true, default: []

      t.timestamps
    end
  end
end
