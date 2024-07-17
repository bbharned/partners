class EventAttendee < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
	validates_uniqueness_of :event_id, :scope => :user_id



def self.to_csv
      attributes = %w{id active firstname lastname email company attended passed prttype channel continent created_at lastlogin}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |user|
          csv << attributes.map{ |attr| user.send(attr) }
        end
      end
end	

private



end