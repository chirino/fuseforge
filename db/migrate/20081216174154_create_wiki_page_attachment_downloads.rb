class CreateWikiPageAttachmentDownloads < ActiveRecord::Migration
  def self.up
    create_table :wiki_page_attachment_downloads do |t|
      t.integer :wiki_page_attachment_id
      t.integer :downloaded_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :wiki_page_attachment_downloads
  end
end
