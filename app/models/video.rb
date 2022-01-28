class Video < ActiveRecord::Base
	has_many :quiz_videos
	has_many :quizzes, through: :quiz_videos
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	



end