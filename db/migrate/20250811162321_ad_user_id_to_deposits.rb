class AdUserIdToDeposits < ActiveRecord::Migration[8.0]
  def change
    add_reference :deposits, :user, null: false, foreign_key: true
  end
end
