class CreateLicenses < ActiveRecord::Migration[5.2]
  def change
    create_table :licenses do |t|
      t.integer :user_id
      t.string :license_type
      t.string :activation_type
      t.string :product_license
      t.string :serial_number
      t.date :enddate
      t.boolean :approved, default: false
      t.text :note
      t.timestamps
    end
  end
end
