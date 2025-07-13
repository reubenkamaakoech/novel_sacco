class AddUniqueIndexToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_index :attendances, [:employee_id, :work_date], unique: true
  end
end
