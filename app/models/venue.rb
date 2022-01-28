class Venue < ActiveRecord::Base
	has_many :event_venues
    has_many :events, through: :event_venues
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	validates_uniqueness_of :name


	def self.options_for_select
      order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
    end

end