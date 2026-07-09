class AddIsRefinanceSettlementToLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    add_column :loan_repayments, :is_refinance_settlement, :boolean, default: false, null: false
  end
end
