class AddNotesToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :notes, :text
  end
end
