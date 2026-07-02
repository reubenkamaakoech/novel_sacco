class AddTransactionTypeToSavings < ActiveRecord::Migration[8.0]
   def up
    add_column :savings, :transaction_type, :string, default: "deposit", null: false

    Saving.update_all(transaction_type: "deposit")
  end

  def down
    remove_column :savings, :transaction_type
  end
end
