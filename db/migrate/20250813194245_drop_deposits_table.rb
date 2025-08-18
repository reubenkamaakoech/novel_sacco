class DropDepositsTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :deposits, if_exists: true
  end

  def down
    create_table :deposits do |t|
      t.references :member, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :deposit_type, null: false # "monthly" or "random"
      t.date :month # only used for monthly contributions
      t.timestamps
    end
  end
end