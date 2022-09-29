class AddPrivateToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :private, :boolean, default: false
  end
end
