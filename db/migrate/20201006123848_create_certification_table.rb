class CreateCertificationTable < ActiveRecord::Migration[5.2]
  def change
    create_table :certifications do |t|
    	t.integer :user_id
    	t.string :name
    	t.float :version
    	t.date :date_earned
    	t.date :exp_date
    	t.boolean :active, default: true
    	t.timestamps
    end
  end
end
