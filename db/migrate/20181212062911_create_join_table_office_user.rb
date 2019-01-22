# frozen_string_literal: true

class CreateJoinTableOfficeUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :offices, :users do |t|
      # t.index [:office_id, :user_id]
      # t.index [:user_id, :office_id]
    end
  end
end
