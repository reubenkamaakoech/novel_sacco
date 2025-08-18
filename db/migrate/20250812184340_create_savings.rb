class CreateSavings < ActiveRecord::Migration[8.0]
  def change
    create_table :savings do |t|
      t.references :member, null: false, foreign_key: true
      t.decimal :amount
      t.string :deposit_type
      t.date :month
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
