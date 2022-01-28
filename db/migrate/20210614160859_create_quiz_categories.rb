class CreateQuizCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :quiz_categories do |t|
      t.integer :quiz_id
      t.integer :category_id
    end
  end
end
