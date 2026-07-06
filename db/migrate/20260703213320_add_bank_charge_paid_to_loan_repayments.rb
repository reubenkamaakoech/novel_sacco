class AddBankChargePaidToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loan_repayments, :bank_charge_paid, :decimal
  end
end
