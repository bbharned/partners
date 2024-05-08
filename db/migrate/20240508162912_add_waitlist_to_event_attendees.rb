class AddWaitlistToEventAttendees < ActiveRecord::Migration[6.1]
  def change
    add_column :event_attendees, :waitlist, :boolean, default: false
  end
end
