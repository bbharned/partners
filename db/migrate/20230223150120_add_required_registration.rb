class AddRequiredRegistration < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :reg_required, :boolean, default: true
  end
end
