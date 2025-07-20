class RemoveSignUpsEnabledFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :sign_ups_enabled, :boolean
  end
end
