class ChangeUsersAdminColumn < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :admin
  	add_column :users, :admin, :boolean, default: :false
  end
end
