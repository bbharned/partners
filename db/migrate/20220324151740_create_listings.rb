class CreateListings < ActiveRecord::Migration[5.2]
  def change
    create_table :listings do |t|
      t.string :firstname
      t.string :lastname
      t.string :fullname
      t.integer :company_id
      t.boolean :active, default: false
      t.string :email
      t.string :phone
      t.integer :user_id
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :country_code
      t.float :latitude
      t.float :longitude
      t.string :map_path
      t.string :story_path
      t.string :list_type
      t.integer :priority
      t.text :keywords
      t.text :description
      t.timestamps
    end
  end
end
