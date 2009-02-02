class CreateProjectNewsItems < ActiveRecord::Migration
  def self.up
    create_table :project_news_items do |t|
      t.integer :project_id
      t.string :title
      t.text :contents
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :project_news_items
  end
end
