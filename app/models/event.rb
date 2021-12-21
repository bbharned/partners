class Event < ActiveRecord::Base
	has_many :event_categories
    has_many :evtcategories, through: :event_categories
    has_many :event_venues
    has_many :venues, through: :event_venues
    has_many :event_tags
    has_many :tags, through: :event_tags
    has_many :event_attendees, :dependent => :destroy
    has_many :users, through: :event_attendees
    validates :name, presence: true, length: { minimum:3, maximum: 100 }
    


end