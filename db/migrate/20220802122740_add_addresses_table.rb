class AddAddressesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :addaddresses do |t|
      t.integer :company_id
      t.string :street
      t.string :street2
      t.string :street3
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :country_code
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end