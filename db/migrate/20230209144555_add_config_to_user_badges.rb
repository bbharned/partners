class AddConfigToUserBadges < ActiveRecord::Migration[6.1]
  def change
    add_column :user_badges, :configuration, :boolean, default: false
  end
end
