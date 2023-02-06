class AddEventColumnsToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :evtcategories, :private, :boolean, default: false
    add_column :events, :evt_link, :string
  end
end
