class CreatePayrolls < ActiveRecord::Migration[8.0]
  def change
    create_table :payrolls do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :period
      t.integer :worked_days
      t.decimal :total_pay
      t.decimal :advance
      t.decimal :payable

      t.timestamps
    end
  end
end
