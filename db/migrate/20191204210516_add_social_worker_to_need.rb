class AddSocialWorkerToNeed < ActiveRecord::Migration[6.0]
  def change
    add_reference :needs, :social_worker
  end
end
