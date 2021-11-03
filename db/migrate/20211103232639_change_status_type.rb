class ChangeStatusType < ActiveRecord::Migration[6.1]
  def change
    change_column :shift_surveys, :status, :string, :default => "Incomplete"

  end
end
