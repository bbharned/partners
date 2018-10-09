class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    	t.string :firstname
    	t.string :lastname
    	t.string :email
    	t.string :company
    	t.string :prttype
    	t.string :silevel
    	t.string :channel
    	t.boolean :active
    	t.boolean :admin
    	t.timestamps
    end
  end
end
