class Video < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	



end