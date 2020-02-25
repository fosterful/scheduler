# frozen_string_literal: true

class CreateOfficeUsers < ActiveRecord::Migration[6.0]
  def change
    rename_table :offices_users, :office_users
    change_table :office_users, bulk: true do |t|
      t.primary_key :id
      t.boolean :send_notifications, default: false, null: false
    end
  end
end
