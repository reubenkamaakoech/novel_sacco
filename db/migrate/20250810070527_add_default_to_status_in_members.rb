class AddDefaultToStatusInMembers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :members, :status, default: true, null: false
  end
end
