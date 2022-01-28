class AddAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :street, :string
    add_column :users, :street2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :integer
    add_column :users, :cell, :string
    add_column :users, :carrier, :string
  end
end
