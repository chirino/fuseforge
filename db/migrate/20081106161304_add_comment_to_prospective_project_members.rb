class AddCommentToProspectiveProjectMembers < ActiveRecord::Migration
  def self.up
    add_column :prospective_project_members, :comment, :text
  end

  def self.down
    remove_column :prospective_project_members, :comment
  end
end
