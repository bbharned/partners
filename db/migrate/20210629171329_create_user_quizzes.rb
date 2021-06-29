class CreateUserQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_quizzes do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.timestamps
    end
  end
end
