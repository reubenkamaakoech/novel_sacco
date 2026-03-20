class ChangeLockedSavingsPercentageToIntegerInAppConfigs < ActiveRecord::Migration[8.0]
  def change
    change_column :app_configs, :locked_savings_percentage, :integer
  end
end
