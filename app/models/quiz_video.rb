class QuizVideo < ActiveRecord::Base
	belongs_to :video
	belongs_to :quiz
end