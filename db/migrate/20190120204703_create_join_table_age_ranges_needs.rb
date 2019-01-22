# frozen_string_literal: true

class CreateJoinTableAgeRangesNeeds < ActiveRecord::Migration[5.2]
  def change
    create_join_table :age_ranges, :needs do |t|
      # t.index [:age_range_id, :need_id]
      # t.index [:need_id, :age_range_id]
    end
  end
end
