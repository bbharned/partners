class AddTzToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :tzid, :string, default: "America/New_York"
  end
end
