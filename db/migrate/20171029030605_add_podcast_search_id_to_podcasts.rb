class AddPodcastSearchIdToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :podcast_search_id, :integer
    add_index :podcasts, :podcast_search_id
  end
end
