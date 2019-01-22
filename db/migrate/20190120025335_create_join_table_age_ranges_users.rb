# frozen_string_literal: true

class CreateJoinTableAgeRangesUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :age_ranges, :users do |t|
      # t.index [:age_range_id, :user_id]
      # t.index [:user_id, :age_range_id]
    end
  end
end
