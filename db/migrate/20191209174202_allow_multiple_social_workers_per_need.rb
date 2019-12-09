class AllowMultipleSocialWorkersPerNeed < ActiveRecord::Migration[6.0]
  def change
    remove_column :needs, :social_worker_id
    create_table :needs_social_workers do |t|
      t.references :need, null: false
      t.references :social_worker, null: false
    end
  end
end
