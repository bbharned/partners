class CreateTermTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :term_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
