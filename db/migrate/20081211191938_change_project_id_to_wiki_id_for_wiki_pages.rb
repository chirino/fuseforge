class ChangeProjectIdToWikiIdForWikiPages < ActiveRecord::Migration
  def self.up
    rename_column :wiki_pages, :project_id, :wiki_id
  end

  def self.down
    rename_column :wiki_pages, :wiki_id, :project_id
  end
end
