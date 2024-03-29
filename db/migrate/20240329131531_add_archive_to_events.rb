class AddArchiveToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :archive, :boolean, default: false
  end
end
