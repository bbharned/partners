class ChangeHardwareFirmwares < ActiveRecord::Migration[5.2]
  def change
    change_column :hardwares, :min_firmware, :number
    change_column :hardwares, :max_firmware, :number
  end
end
