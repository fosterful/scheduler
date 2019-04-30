class AddCountyToAddresses < ActiveRecord::Migration[5.2]
  def up
    add_column :addresses, :county, :string
    populate_county_data
    change_column_null :addresses, :county, false
  end

  def down
    remove_column :addresses, :county, :string
  end

  def populate_county_data
    Address.find_each do |address|
      address.send(:validate_and_geocode)
      address.save
    end
  end
end
