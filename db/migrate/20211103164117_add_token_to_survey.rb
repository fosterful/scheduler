class AddTokenToSurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :shift_surveys, :token, :string
  end
end