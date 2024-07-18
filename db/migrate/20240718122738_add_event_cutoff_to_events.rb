class AddEventCutoffToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :cutoff, :integer, default: 48
  end
end
