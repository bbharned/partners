class CreateHardwares < ActiveRecord::Migration[5.2]
  def change
    create_table :hardwares do |t|
      t.references :maker
      t.references :hwstatus
      t.references :hwtype
      t.string :model
      t.string :terminal_type
      t.string :min_firmware
      t.string :max_firmware
      t.string :hardware_gpu_id
      t.string :cpu
      t.string :touch_interface
      t.string :network_card
      t.string :pci_network_id
      t.text :note
      t.timestamps
    end
  end
end
