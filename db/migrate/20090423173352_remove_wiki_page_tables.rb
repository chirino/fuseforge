class RemoveWikiPageTables < ActiveRecord::Migration
  def self.up
    drop_table :wiki_page_attachment_downloads
    drop_table :wiki_page_attachments
    drop_table :wiki_page_versions
    drop_table :wiki_pages
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted wiki tables"
  end
end
