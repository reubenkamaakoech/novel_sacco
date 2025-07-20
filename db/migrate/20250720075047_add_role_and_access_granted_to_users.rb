class AddRoleAndAccessGrantedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string
    add_column :users, :access_granted, :boolean
    remove_column :users, :admin
  end
end
