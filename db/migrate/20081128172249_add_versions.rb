class AddVersions < ActiveRecord::Migration
  def self.up
    create_table :wiki_page_versions do |t|
      t.integer :wiki_page_id
      t.integer :version
      t.string :slug
      t.text :body
      t.integer :created_by_id
      t.integer :updated_by_id
      t.datetime :updated_at
      t.integer :project_id
    end
  end

  def self.down
    drop_table :wiki_page_versions
  end
end
