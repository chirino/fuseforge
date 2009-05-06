class AddGitRepos < ActiveRecord::Migration
  def self.up
    create_table :git_repos do |t|
      t.integer :project_id
      t.boolean :use_internal      
      t.string :external_anonymous_url
      t.string :external_commit_url
      t.string :external_web_url
    end
    
   add_index(:git_repos, :project_id, :unique => true)
    
    #
    # Add a GitRepo to all the projects.
    #
    Project.all.each do |project|
      GitRepo.new(:use_internal => false, :project=>project).save
    end
    
  end

  def self.down
    remove_index :git_repos, :column=>:project_id
    drop_table :git_repos
  end
end
