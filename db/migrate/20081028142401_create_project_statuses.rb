class CreateProjectStatuses < ActiveRecord::Migration
  def self.up
    create_table :project_statuses do |t|
      t.string :name
      t.string :description
      t.integer :position

      t.timestamps
    end
    
    ProjectStatus.create(:name => 'Active')
    ProjectStatus.create(:name => 'Unapproved')
    ProjectStatus.create(:name => 'Inactive')
  end

  def self.down
    drop_table :project_statuses
  end
end
