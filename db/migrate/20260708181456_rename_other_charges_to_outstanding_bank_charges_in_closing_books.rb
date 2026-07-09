class RenameOtherChargesToOutstandingBankChargesInClosingBooks < ActiveRecord::Migration[8.0]
  def change
    rename_column :closing_books, :other_charges, :outstanding_bank_charges
  end
end
