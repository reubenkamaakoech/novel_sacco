class ChangeSiteIdToNullableInAttendances < ActiveRecord::Migration[8.0]
  def change
    change_column_null :attendances, :site_id, true
  end
end
