class CreatePodcastSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_searches do |t|

      t.timestamps
    end
  end
end
