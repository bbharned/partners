class Tag < ActiveRecord::Base
	has_many :event_tags
    has_many :events, through: :event_tags

end