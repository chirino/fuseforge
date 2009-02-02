class CreateProjectCategories < ActiveRecord::Migration
  def self.up
    create_table :project_categories do |t|
      t.string :name
      t.string :description
      t.integer :position

      t.timestamps
    end
    
    ProjectCategory.create(:name => 'Transports')
    ProjectCategory.create(:name => 'Modules')
    ProjectCategory.create(:name => 'Tools')
    ProjectCategory.create(:name => 'Documentation')
  end

  def self.down
    drop_table :project_categories
  end
end
