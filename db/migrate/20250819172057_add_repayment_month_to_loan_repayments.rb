class AddRepaymentMonthToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loan_repayments, :repayment_month, :date, null: false
  end
end
