class AddIsPrivateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :is_private, :boolean
  end

  def self.down
    remove_column :projects, :is_private
  end
end
