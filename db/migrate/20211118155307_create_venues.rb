class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :url
      t.timestamps
    end
  end
end
