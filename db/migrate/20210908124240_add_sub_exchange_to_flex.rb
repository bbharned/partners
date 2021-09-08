class AddSubExchangeToFlex < ActiveRecord::Migration[5.2]
  def change
    add_column :flexforwards, :sub_exchange, :boolean, default: false
  end
end
