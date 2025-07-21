class RemoveSignupEnabledFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :signup_enabled, :boolean
  end
end
