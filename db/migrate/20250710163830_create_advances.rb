class CreateAdvances < ActiveRecord::Migration[8.0]
  def change
    create_table :advances do |t|
      t.references :employee, null: false, foreign_key: true
      t.decimal :amount
      t.date :date

      t.timestamps
    end
  end
end
