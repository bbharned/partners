class CreateRoiTable < ActiveRecord::Migration[6.1]
  def change
    create_table :rois do |t|
      #Scenerio
      t.integer :user_id
      t.integer :currency_id
      t.string :name
      t.string :activation_type
      t.string :support_level

      #General
      






      t.timestamps
    end
  end
end
