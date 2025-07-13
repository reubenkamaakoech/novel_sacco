class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :full_name
      t.decimal :daily_pay
      t.string :phone
      t.string :national_id

      t.timestamps
    end
  end
end
