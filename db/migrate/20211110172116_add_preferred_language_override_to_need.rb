class AddPreferredLanguageOverrideToNeed < ActiveRecord::Migration[6.1]
  def change
    add_column :needs, :preferred_language_override, :boolean, default: false
  end
end