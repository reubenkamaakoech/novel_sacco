class AddUserIdToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_reference :attendances, :user, null: false, foreign_key: true, default: 1
    add_reference :payrolls, :user, null: false, foreign_key: true, default: 1
    add_reference :advances, :user, null: false, foreign_key: true, default: 1
    add_reference :employees, :user, null: false, foreign_key: true, default: 1 
    add_reference :sites, :user, null: false, foreign_key: true, default: 1
  end
end
