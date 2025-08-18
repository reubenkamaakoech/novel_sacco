class AddNextOfKinRelationship < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :next_of_kin_relationship, :string   
  end
end
