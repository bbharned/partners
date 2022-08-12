class AddDemokitTable < ActiveRecord::Migration[5.2]
  def change
    create_table :demokits do |t|
      t.integer :user_id
      t.integer :serial_number
      t.string :reason
      t.string :region
      t.string :tmversion
      t.string :esxiversion
      t.string :status
      t.date :change_date
      t.text :notes
      t.timestamps
    end
  end
end
