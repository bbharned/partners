class Evtcategory < ActiveRecord::Base
	has_many :event_categories
    has_many :events, through: :event_categories
    has_many :event_tags
    has_many :tags
    validates :name, presence: true, length: {minimum: 3, maximum: 25}
    validates_uniqueness_of :name
	
    def self.options_for_select
      order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
    end
    
end