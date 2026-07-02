class AddLoanBalanceToClosingBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :closing_books, :loan_balance, :decimal
  end
end
