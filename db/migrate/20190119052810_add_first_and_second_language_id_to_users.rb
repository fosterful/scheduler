# frozen_string_literal: true

class AddFirstAndSecondLanguageIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_language_id, :bigint
    add_column :users, :second_language_id, :bigint
  end
end
