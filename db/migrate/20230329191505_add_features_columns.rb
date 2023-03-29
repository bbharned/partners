class AddFeaturesColumns < ActiveRecord::Migration[6.1]
  def change

    create_table :tmprereqs do |t|
      t.string :name
      t.timestamps
    end

    create_join_table :features, :tmprereqs do |t|
      t.index :feature_id
      t.index :tmprereq_id
      t.timestamps
    end


  end
end
