class AddBalancesToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loan_repayments, :balance_after, :decimal
  end
end
