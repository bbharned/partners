class AddArchiveToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :archive, :boolean, default: false
  end
end
