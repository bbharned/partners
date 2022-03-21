class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :url
      t.string :phone
      t.string :email
      t.string :logo_path
      t.string :story_path
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :country_code
      t.float :latitude
      t.float :longitude
      t.string :map
      t.string :main_prt_type
      t.text :description
      t.timestamps
    end
  end
end
