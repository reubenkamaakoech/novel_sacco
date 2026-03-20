class AddUserIdToAppConfigs < ActiveRecord::Migration[8.0]
  def change
    add_reference :app_configs, :user, null: false, foreign_key: true
  end
end
