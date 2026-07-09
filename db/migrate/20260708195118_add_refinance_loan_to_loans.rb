class AddRefinanceLoanToLoans < ActiveRecord::Migration[8.0]
  def change
    add_reference :loans,
              :refinanced_from,
              foreign_key: { to_table: :loans }

    add_column :loans, :is_refinance, :boolean, default: false
  end
end
