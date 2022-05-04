class CreateTermnotesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :termnotes do |t|

      t.string :termcapmodel
      t.text :note
      t.timestamps
   
    end
  end
end
