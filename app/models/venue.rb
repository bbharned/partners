class Venue < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	validates_uniqueness_of :name



end