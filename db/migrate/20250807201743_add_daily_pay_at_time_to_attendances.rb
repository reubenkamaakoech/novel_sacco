class AddDailyPayAtTimeToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_column :attendances, :daily_pay_at_time, :decimal
  end
end
