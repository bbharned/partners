class CreateMatrix < ActiveRecord::Migration[6.1]
  def change
    
    create_table :features do |t|
      t.string :name
      t.text :description
      t.string :more_link_label
      t.string :more_link
      t.string :more_more_link_label
      t.string :more_more_link
      t.string :more_more_more_link_label
      t.string :more_more_more_link
      t.string :image_link
      t.timestamps
    end

    create_table :tmversions do |t|
      t.string :version
      t.timestamps
    end

    create_table :firmwarebuilds do |t|
      t.string :build
      t.timestamps
    end

    create_join_table :features, :tmversions do |t|
      t.index :feature_id
      t.index :tmversion_id
      t.timestamps
    end

    create_join_table :features, :firmwarebuilds do |t|
      t.index :feature_id
      t.index :firmwarebuild_id
      t.timestamps
    end

  end


end
