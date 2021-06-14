class Quiz < ActiveRecord::Base
	has_many :quiz_categories
	has_many :categories, through: :quiz_categories
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	validates_uniqueness_of :name



end