class AddPassedBooleanToEventAttendees < ActiveRecord::Migration[6.1]
  def change
    add_column :event_attendees, :passed, :boolean, default: false
  end
end
