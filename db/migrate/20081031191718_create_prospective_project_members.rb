class CreateProspectiveProjectMembers < ActiveRecord::Migration
  def self.up
    create_table :prospective_project_members do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :prospective_project_members
  end
end
