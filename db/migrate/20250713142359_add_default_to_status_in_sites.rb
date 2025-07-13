class AddDefaultToStatusInSites < ActiveRecord::Migration[8.0]
  def change
    change_column_default :sites, :status, default: true, null: false
  end
end
