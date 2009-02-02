class AddProjectIdToWikiPages < ActiveRecord::Migration
  def self.up
    add_column :wiki_pages, :project_id, :integer
  end

  def self.down
    remove_column :wiki_pages, :project_id
  end
end
