class AddEvtcatagoryIdToEventTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :description, :text
    add_column :event_tags, :evtcategory_id, :integer
  end
end
