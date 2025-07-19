class RemoveDefaultFromDailyPayAtTimeInPayrolls < ActiveRecord::Migration[8.0]
  def change
    change_column_default :payrolls, :daily_pay_at_time, from: 0, to: nil
  end
end
