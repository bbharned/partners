class AddCheckinToEventAttendees < ActiveRecord::Migration[5.2]
  def change
    add_column :event_attendees, :checkedin, :boolean, default: false
    add_column :event_attendees, :lastname, :string
  end
end
