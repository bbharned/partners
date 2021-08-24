class AddPriorityToHardwares < ActiveRecord::Migration[5.2]
  def change
    add_column :hardwares, :priority, :string, default: "e"
  end
end
