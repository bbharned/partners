class CreateEventCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :event_categories do |t|
      t.integer :event_id
      t.integer :evtcategory_id
    end
  end
end