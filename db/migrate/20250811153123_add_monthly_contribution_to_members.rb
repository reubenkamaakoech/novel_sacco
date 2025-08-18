class AddMonthlyContributionToMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :monthly_contribution, :decimal
  end
end
