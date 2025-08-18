class CreateLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    create_table :loan_repayments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :loan, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
