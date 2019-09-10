class AddCertDatesToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :certdate, :date
  	add_column :users, :certexpire, :date
  end
end
