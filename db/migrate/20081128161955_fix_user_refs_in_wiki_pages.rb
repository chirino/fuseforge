class FixUserRefsInWikiPages < ActiveRecord::Migration
  def self.up
    rename_column :wiki_pages, :created_by, :created_by_id
    rename_column :wiki_pages, :updated_by, :updated_by_id
  end

  def self.down
    rename_column :wiki_pages, :created_by_id, :created_by
    rename_column :wiki_pages, :updated_by_id, :updated_by
  end
end
