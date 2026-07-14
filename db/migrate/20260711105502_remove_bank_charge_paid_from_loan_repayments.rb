class RemoveBankChargePaidFromLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :bank_charge_paid, :boolean, default: false, null: false
  end
end
