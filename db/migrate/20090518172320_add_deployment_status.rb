class AddDeploymentStatus < ActiveRecord::Migration
  def self.up
    add_column :wikis, :last_permissions, :text

    create_table :deployment_statuses do |t|
      t.integer  :project_id
      t.integer  :job_id
      t.integer  :next, :integer, :default => 0
      t.integer  :last, :integer, :default => 0
    end

    add_index(:deployment_statuses, :project_id, :unique => true)
    
    Project.all.each do |project|
      DeploymentStatus.new(:project=>project).save
      project.wiki.last_permissions = project.wiki.all_permissions
      project.wiki.save
    end
        
  end

  def self.down
    remove_column :wikis, :last_permissions
    drop_table :deployment_statuses
  end
end
