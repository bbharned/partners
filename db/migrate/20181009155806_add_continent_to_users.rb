class AddContinentToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :continent, :string
  end
end
