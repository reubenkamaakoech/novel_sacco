class AddRepaymentDateToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loan_repayments, :repayment_date, :date
  end
end
