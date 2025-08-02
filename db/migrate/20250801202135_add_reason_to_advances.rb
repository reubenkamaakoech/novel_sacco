class AddReasonToAdvances < ActiveRecord::Migration[8.0]
  def change
    add_column :advances, :reason, :string
  end
end
