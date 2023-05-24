class AddEventSignUpBool < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :event_signup, :boolean, default: false
  end
end
