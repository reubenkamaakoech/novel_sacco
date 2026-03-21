class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :role
      t.string :resource
      t.boolean :can_create, default: false, null: false
      t.boolean :can_read, default: false, null: false
      t.boolean :can_update, default: false, null: false
      t.boolean :can_delete, default: false, null: false
      t.timestamps
    end
  end
end
