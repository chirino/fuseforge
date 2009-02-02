class AddDownloadTrackingToWikiPageAttachments < ActiveRecord::Migration
  def self.up
    add_column :wiki_page_attachments, :track_downloads, :boolean
    add_column :wiki_page_attachments, :include_in_project_homepage_download_stats, :boolean
  end

  def self.down
    remove_column :wiki_page_attachments, :track_downloads
    remove_column :wiki_page_attachments, :include_in_project_homepage_download_stats
  end
end
