class ChangeFirmwaresInhardware < ActiveRecord::Migration[5.2]
  def change
    change_column :hardwares, :min_firmware, :decimal
    change_column :hardwares, :max_firmware, :decimal
    change_column :firmwares, :version, :decimal
  end
end
