class ChangeFirmwaresInhardware < ActiveRecord::Migration[5.2]
  def change
    remove_column :hardwares, :min_firmware
    remove_column :hardwares, :max_firmware
    remove_column :firmwares, :version
    add_column :hardwares, :min_firmware, :decimal
    add_column :hardwares, :max_firmware, :decimal
    add_column :firmwares, :version, :decimal
  end
end
