class AddProjectIdToProjectGroups < ActiveRecord::Migration
  def self.up
    add_column :project_groups, :project_id, :integer
  end

  def self.down
    remove_column :project_groups, :project_id
  end
end
