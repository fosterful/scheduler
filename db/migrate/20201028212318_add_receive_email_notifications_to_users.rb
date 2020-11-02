class AddReceiveEmailNotificationsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_email_notifications, :boolean, null: false, default: false
  end
end
