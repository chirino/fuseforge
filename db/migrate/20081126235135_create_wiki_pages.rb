class CreateWikiPages < ActiveRecord::Migration
  def self.up
    create_table :wiki_pages do |t|
      t.string :slug
      t.text :body
      t.integer :version
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :wiki_pages
  end
end
