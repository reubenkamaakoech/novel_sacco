class AddJobCategoryToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_column :employees, :job_category, :string, default: 1 , null: false
  end
end
