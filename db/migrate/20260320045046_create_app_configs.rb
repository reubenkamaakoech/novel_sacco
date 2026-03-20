class CreateAppConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :app_configs do |t|
      t.decimal :locked_savings_percentage

      t.timestamps
    end
  end
end
