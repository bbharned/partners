class ChangeVariableTypes < ActiveRecord::Migration[6.1]
  def change
    change_column :venues, :zipcode, :string
    change_column :users, :zip, :string
  end
end
