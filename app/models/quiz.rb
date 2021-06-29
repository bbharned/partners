class Quiz < ActiveRecord::Base
	has_many :quiz_categories
	has_many :categories, through: :quiz_categories
	has_many :quiz_questions
	has_many :questions, through: :quiz_questions
	has_many :quiz_videos
	has_many :videos, through: :quiz_videos
	has_many :wrongs
	has_many :user_quizzes
    has_many :users, through: :user_quizzes
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	validates_uniqueness_of :name
	accepts_nested_attributes_for :questions



end