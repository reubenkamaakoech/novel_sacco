class FixStatusColumnInUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :status
    add_column :users, :status, :boolean, default: true
  end
end
