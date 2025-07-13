class AddStatusToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_column :employees, :status, :boolean, default: true, null: false
  end
end
