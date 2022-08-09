class AddDemokitTable < ActiveRecord::Migration[5.2]
  def change
    create_table :demokits do |t|
      t.integer :serial_number
      t.string :reason
      t.string :region
      t.string :tmversion
      t.string :esxiversion
      t.string :status
      t.string :firstname
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :company
      t.string :street
      t.string :street2
      t.string :street3
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone
      t.date :change_date
      t.text :notes
      t.timestamps
    end
  end
end
