class AddRaceRelationshipToNeeds < ActiveRecord::Migration[5.2]
  def change
    add_reference :needs, :race
  end
end
