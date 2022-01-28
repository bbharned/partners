class AddImagesToCatAndGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :image_link, :string
    add_column :evtcategories, :image_link, :string
  end
end
