class ChangeNeedPreferredLanguageIdToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :needs, :preferred_language_id, false
  end
end
