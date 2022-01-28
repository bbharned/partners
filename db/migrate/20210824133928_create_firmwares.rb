class CreateFirmwares < ActiveRecord::Migration[5.2]
  def change
    create_table :firmwares do |t|
      t.string :version
      t.timestamps
    end
  end
end
