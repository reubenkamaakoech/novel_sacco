class ChangeBankChargePaidToBooleanInLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    change_column :loan_repayments,
                  :bank_charge_paid,
                  :boolean,
                  default: false,
                  null: false
  end
end
