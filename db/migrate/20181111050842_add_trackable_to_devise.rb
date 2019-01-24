class AddTrackableToDevise < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sign_in_count, :integer
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :integer
    add_column :users, :last_sign_in_ip, :integer
  end
end
