class CreateClosingBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :closing_books do |t|
      t.references :member, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :closing_date
      t.decimal :total_savings
      t.decimal :withdrawal_charges
      t.decimal :other_charges
      t.decimal :amount_paid
      t.text :remarks

      t.timestamps
    end
  end
end
