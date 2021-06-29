class CreateUserBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_badges do |t|
      t.integer :user_id
      t.boolean :productivity, default: false
      t.boolean :visualization, default: false
      t.boolean :security, default: false
      t.boolean :mobility, default: false
      t.timestamps
    end
  end
end
