class AddUniqueIndexToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_index :loan_repayments, [:loan_id, :repayment_month], unique: true
  end
end
