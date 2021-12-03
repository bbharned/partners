class Evtcategory < ActiveRecord::Base
	has_many :event_categories
    has_many :events, through: :event_categories
    validates :name, presence: true, length: {minimum: 3, maximum: 25}
    validates_uniqueness_of :name
	

end