class SetExistingStatusToActive < ActiveRecord::Migration[6.1]
  def up
    active_users = User.where(deactivated: false)
    active_users.update_all(status: 'active')

    inactive_users = User.where(deactivated: true)
    inactive_users.update_all(status: 'inactive')
  end

  def down
    User.update_all(status: nil)
  end
end