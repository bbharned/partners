class ChangeUserColumnActive < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :active
  	add_column :users, :active, :boolean, default: :true
  end
end
