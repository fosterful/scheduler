class AddProfileAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birth_date, :date
    add_column :users, :phone, :string
    add_column :users, :resident_since, :date
    add_column :users, :discovered_omd_by, :text
    add_column :users, :medical_limitations, :boolean
    add_column :users, :medical_limitations_desc, :text
    add_column :users, :conviction, :boolean
    add_column :users, :conviction_desc, :text
  end
end
