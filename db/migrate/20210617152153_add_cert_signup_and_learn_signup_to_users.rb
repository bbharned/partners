class AddCertSignupAndLearnSignupToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cert_signup, :boolean, default: false
    add_column :users, :learn_signup, :boolean, default: false
  end
end
