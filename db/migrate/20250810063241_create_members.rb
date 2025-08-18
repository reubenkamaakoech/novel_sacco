class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :membership_number
      t.string :name
      t.string :id_number
      t.string :phone_number
      t.string :email
      t.date :join_date
      t.boolean :status
      t.string :next_of_kin_name
      t.string :next_of_kin_contact

      t.timestamps
    end
  end
end
