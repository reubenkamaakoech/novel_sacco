class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :interior_area
      t.integer :exterior_area

      t.timestamps
    end
  end
end
