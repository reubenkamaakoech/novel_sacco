class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_table :loans do |t|
      t.references :member, null: false, foreign_key: true
      t.decimal :available_amount
      t.decimal :amount
      t.string :payment_period_months
      t.decimal :repayment_amount_per_month

      t.timestamps
    end
  end
end
