class AddUnavailableUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :unavailable_user_ids, :bigint, default: [], array: true
  end
end
