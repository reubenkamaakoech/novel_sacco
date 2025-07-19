class AddDailyPayAtTimeToPayrolls < ActiveRecord::Migration[8.0]
  def change
    add_column :payrolls, :daily_pay_at_time, :decimal, default: "0.00"
  end
end
