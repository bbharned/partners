class EventVenue < ActiveRecord::Base
    belongs_to :event
    belongs_to :venue
end