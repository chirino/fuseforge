class RemoveIsActiveFromComponents < ActiveRecord::Migration
  def self.up
    remove_column :issue_trackers, :is_active
    remove_column :repositories, :is_active
    remove_column :wikis, :is_active
  end

  def self.down
    add_column :issue_trackers, :is_active, :boolean
    add_column :repositories, :is_active, :boolean
    add_column :wikis, :is_active, :boolean
  end
end
