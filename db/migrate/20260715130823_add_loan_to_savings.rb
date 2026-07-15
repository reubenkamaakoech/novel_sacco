class AddLoanToSavings < ActiveRecord::Migration[8.0]
  def change
    add_reference :savings, :loan, null: true, foreign_key: true
  end
end
