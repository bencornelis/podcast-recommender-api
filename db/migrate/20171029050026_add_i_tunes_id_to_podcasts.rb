class AddITunesIdToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :itunes_id, :integer
  end
end
