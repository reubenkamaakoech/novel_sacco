class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.boolean :sign_ups_enabled

      t.timestamps
    end
  end
end
