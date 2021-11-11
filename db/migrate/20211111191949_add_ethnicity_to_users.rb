class AddEthnicityToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hispanic, :boolean
  end
end
