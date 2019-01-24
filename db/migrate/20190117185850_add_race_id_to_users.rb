class AddRaceIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :race_id, :bigint
  end
end
