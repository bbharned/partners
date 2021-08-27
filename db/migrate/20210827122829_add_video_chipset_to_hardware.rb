class AddVideoChipsetToHardware < ActiveRecord::Migration[5.2]
  def change
    add_column :hardwares, :video_chipset, :string
  end
end
