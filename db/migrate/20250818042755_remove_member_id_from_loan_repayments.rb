class RemoveMemberIdFromLoanRepayments < ActiveRecord::Migration[8.0]
  def change
    remove_reference :loan_repayments, :member, null: false, foreign_key: true
  end
end
