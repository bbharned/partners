class AddNotesToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notes, :text
    add_column :companies, :notes, :text
  end
end
