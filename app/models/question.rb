class Question < ActiveRecord::Base
     has_many :quiz_questions
     has_many :quizzes, through: :quiz_questions
     #accepts_nested_attributes_for :answers
     has_many :answers, dependent: :destroy
     has_many :wrongs, dependent: :destroy



end

