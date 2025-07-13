class AddStatusToSites < ActiveRecord::Migration[8.0]
  def change
    add_column :sites, :status, :boolean
    add_column :sites, :labour_cost, :dcimal
  end
end
