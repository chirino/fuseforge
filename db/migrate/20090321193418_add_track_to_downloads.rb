class AddTrackToDownloads < ActiveRecord::Migration
  def self.up
    add_column :downloads, :track, :boolean, :default => false
  end

  def self.down
    remove_column :downloads, :track
  end
end
