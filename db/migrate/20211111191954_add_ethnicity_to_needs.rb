class AddEthnicityToNeeds < ActiveRecord::Migration[6.1]
  def change
    add_column :needs, :hispanic_volunteer, :boolean
  end
end
