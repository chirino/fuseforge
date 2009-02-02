class RenameActiveInIssueTrackers < ActiveRecord::Migration
  def self.up
    rename_column :issue_trackers, :active, :is_active
  end

  def self.down
    rename_column :issue_trackers, :is_active, :active
  end
end
