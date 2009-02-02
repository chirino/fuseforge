class ChangeProjectIdToWikiIdForWikiPageVersions < ActiveRecord::Migration
  def self.up
    rename_column :wiki_page_versions, :project_id, :wiki_id
  end

  def self.down
    rename_column :wiki_page_versions, :wiki_id, :project_id
  end
end
