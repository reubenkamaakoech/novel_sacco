class RemoveSiteIdFromEmployees < ActiveRecord::Migration[8.0]
  def change
    remove_column :employees, :site_id, :integer
  end
end
