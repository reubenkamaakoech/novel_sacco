class AddStatusToLoans < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :status, :boolean, default: true, null: false
  end
end
