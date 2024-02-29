class CreateSurveys < ActiveRecord::Migration[6.1]
  def change
    
    create_table :surveys do |t|
      t.string :title
      t.text :description
      t.date :exp_date
      t.string :image_url
      t.boolean :randomize, default: false
      t.boolean :required_user, default: true
      t.boolean :live, default: false
      t.timestamps
    end

    add_column :events, :survey_id, :integer

    create_table :survey_questions do |t|
      t.belongs_to :survey
      t.string :question
      t.string :image_url
      t.string :answer_type
      t.integer :possible_answers, default: 1
      t.timestamps
    end

    create_table :survey_answers do |t|
      t.belongs_to :survey_question
      t.string :answer
      t.string :image_url
      t.timestamps
    end

    create_table :survey_results do |t|
      t.integer :survey_id
      t.integer :survey_question_id
      t.integer :survey_answer_id
      t.integer :user_id
      t.text :user_input
      t.timestamps
    end
  
  end
end
