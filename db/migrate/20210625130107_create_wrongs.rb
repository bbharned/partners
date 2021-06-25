class CreateWrongs < ActiveRecord::Migration[5.2]
  def change
    create_table :wrongs do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.integer :question_id
      t.integer :answer_id
      t.timestamps
    end
  end
end
