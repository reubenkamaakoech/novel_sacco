class AddSignupEnabledToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :signup_enabled, :boolean
  end
end
