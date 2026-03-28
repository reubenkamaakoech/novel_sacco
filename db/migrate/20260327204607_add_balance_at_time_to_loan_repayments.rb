class AddBalanceAtTimeToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loan_repayments, :balance_at_time, :decimal
  end
end
