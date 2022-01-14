class Tag < ActiveRecord::Base
	has_many :event_tags, :dependent => :destroy
  has_many :events, through: :event_tags
  belongs_to :evtcategory


    def self.options_for_select
      order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
    end

end