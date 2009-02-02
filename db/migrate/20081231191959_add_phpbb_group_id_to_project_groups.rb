class AddPhpbbGroupIdToProjectGroups < ActiveRecord::Migration
  def self.up
    add_column :project_groups, :phpbb_group_id, :integer
  end

  def self.down
    remove_column :project_groups, :phpbb_group_id
  end
end
