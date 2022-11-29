class DemokitChange < ActiveRecord::Migration[5.2]
  def change
    change_column :demokits, :serial_number, :string
  end
end
