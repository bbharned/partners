class AddBooleanclassesToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :end_user, :boolean, default: :false
  	add_column :users, :integrator, :boolean, default: :false
  	add_column :users, :distributor, :boolean, default: :false
  	add_column :users, :oem, :boolean, default: :false
  	add_column :users, :needs_review, :boolean, default: :false
  end
end
