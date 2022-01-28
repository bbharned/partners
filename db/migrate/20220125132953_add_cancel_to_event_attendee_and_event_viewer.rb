class AddCancelToEventAttendeeAndEventViewer < ActiveRecord::Migration[5.2]
  def change
    add_column :event_attendees, :canceled, :boolean, default: false
    add_column :events, :viewer, :string
  end
end
