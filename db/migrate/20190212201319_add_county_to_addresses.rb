class AddCountyToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :county, :string, null: false
  end
end
