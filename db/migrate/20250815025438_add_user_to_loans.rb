class AddUserToLoans < ActiveRecord::Migration[8.0]
  def change
    add_reference :loans, :user, null: false, foreign_key: true
  end
end
