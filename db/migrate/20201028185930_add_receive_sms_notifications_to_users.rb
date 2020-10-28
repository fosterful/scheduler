class AddReceiveSmsNotificationsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_sms_notifications, :boolean, default: true, null: false
  end
end
