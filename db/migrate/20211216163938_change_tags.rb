class ChangeTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_tags, :evtcategory_id, :integer
    add_column :tags, :evtcategory_id, :integer
  end
end
