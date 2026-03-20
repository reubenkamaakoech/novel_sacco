class AddDefaultToConfigApp < ActiveRecord::Migration[8.0]
  def change
    change_column_default :app_configs, :locked_savings_percentage, from: nil, to: 0
  end
end
