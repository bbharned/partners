class Question < ActiveRecord::Base
     # attr_accessor :prompt, :answer
     # def initialize(prompt, answer)
     #      @prompt = prompt
     #      @answer = answer
     # end
     #has_many :question_answers, dependent: :destroy
     #has_many :answers, through: :question_answers
     has_many :quiz_questions
     has_many :quizzes, through: :quiz_questions
     #accepts_nested_attributes_for :answers









end

