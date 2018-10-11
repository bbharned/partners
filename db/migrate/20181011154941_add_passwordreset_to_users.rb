class AddPasswordresetToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :reset_digest, :string
  	add_column :users, :reset_sent_at, :datetime
  	add_column :users, :lastlogin, :datetime
  end
end
