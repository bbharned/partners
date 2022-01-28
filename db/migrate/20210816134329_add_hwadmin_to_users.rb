class AddHwadminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hw_admin, :boolean, default: false
    add_column :users, :evt_admin, :boolean, default: false
  end
end
