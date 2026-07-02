class AddLoanChargesToLoans < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :bank_charges, :decimal, default: 0
    add_column :loans, :first_installment, :decimal, default: 0
  end
end
