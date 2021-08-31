class AddTermTypeIdToHardware < ActiveRecord::Migration[5.2]
  def change
    add_column :hardwares, :term_type_id, :integer
  end
end
