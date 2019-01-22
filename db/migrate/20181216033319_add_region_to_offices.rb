# frozen_string_literal: true

class AddRegionToOffices < ActiveRecord::Migration[5.2]
  def change
    add_column :offices, :region, :integer, default: 0, null: false
  end
end
