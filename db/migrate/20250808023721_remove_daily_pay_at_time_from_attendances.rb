class RemoveDailyPayAtTimeFromAttendances < ActiveRecord::Migration[8.0]
  def change
    remove_column :attendances, :daily_pay_at_time, :decimal
  end
end
