class AddVerifiedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :verified, :boolean, null: false, default: false
  end
end
