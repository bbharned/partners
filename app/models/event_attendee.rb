class EventAttendee < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
	before_save :session
	validates_uniqueness_of :event_id, :scope => :user_id

	

private

def session

	if !current_user
		flash[:warning] = "You must be logged in to register for events"
		redirect_to login_path
	else
		
	end

end

end