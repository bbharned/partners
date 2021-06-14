class Category < ActiveRecord::Base
	has_many :quiz_categories
	has_many :quizzes, through: :quiz_categories
	validates :name, presence: true, length: { minimum: 3, maximum: 25 } 
	validates_uniqueness_of :name


	
end