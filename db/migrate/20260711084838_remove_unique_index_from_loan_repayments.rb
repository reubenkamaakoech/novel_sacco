class RemoveUniqueIndexFromLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    remove_index :loan_repayments,
                 column: [:loan_id, :repayment_month],
                 name: "index_loan_repayments_on_loan_id_and_repayment_month"
  end
end
