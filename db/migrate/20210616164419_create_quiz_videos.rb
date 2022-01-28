class CreateQuizVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :quiz_videos do |t|
      t.integer :quiz_id
      t.integer :video_id
      t.timestamps
    end
  end
end
