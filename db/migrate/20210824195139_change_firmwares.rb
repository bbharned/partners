class ChangeFirmwares < ActiveRecord::Migration[5.2]
  def change
    change_column :firmwares, :version, :number
  end
end
