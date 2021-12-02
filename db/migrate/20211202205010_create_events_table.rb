class CreateEventsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :starttime
      t.datetime :endtime
      t.float :cost, default: 0.00
      t.integer :capacity
      t.string :event_contact
      t.string :event_email
      t.string :event_host
      t.string :event_phone
      t.string :event_image
      t.boolean :private
      t.boolean :virtual
      t.timestamps
    end
  end
end
