class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :site, null: false, foreign_key: true
      t.date :work_date

      t.timestamps
    end
  end
end
