class AddDescriptionToEvtcategories < ActiveRecord::Migration[5.2]
  def change
    add_column :evtcategories, :description, :text
  end
end
