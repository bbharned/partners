class Quiz < ActiveRecord::Base
	has_many :quiz_categories
	has_many :categories, through: :quiz_categories
	has_many :quiz_questions
	has_many :questions, through: :quiz_questions
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	validates_uniqueness_of :name



end