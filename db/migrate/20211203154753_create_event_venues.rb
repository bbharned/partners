class CreateEventVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :event_venues do |t|
      t.integer :event_id
      t.integer :venue_id
    end
  end
end
