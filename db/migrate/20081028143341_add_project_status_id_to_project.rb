class AddProjectStatusIdToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :project_status_id, :integer
  end

  def self.down
    remove_column :projects, :project_status_id
  end
end
