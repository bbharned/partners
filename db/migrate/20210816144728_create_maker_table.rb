class CreateMakerTable < ActiveRecord::Migration[5.2]
  def change
    create_table :makers do |t|
      t.string :name
      t.string :logo_path
      t.string :url
      t.text :description
      t.timestamps
    end
  end
end
