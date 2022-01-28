class AddDescriptionToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :description, :text
  end
end
