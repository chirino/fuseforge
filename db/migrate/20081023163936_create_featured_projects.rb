class CreateFeaturedProjects < ActiveRecord::Migration
  def self.up
    create_table :featured_projects do |t|
      t.integer :project_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :featured_projects
  end
end
