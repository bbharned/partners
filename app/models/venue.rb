class Venue < ActiveRecord::Base
	has_many :event_venues
    has_many :events, through: :event_venues
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	validates_uniqueness_of :name



end