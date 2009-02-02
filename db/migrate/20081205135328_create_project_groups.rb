class CreateProjectGroups < ActiveRecord::Migration
  def self.up
    create_table :project_groups do |t|
      t.string :name
      t.string :type
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :project_groups
  end
end
