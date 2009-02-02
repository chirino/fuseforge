class AddCreatedByIdUpdatedByIdToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :created_by_id, :integer
    add_column :projects, :updated_by_id, :integer
  end

  def self.down
    remove_column :projects, :updated_by_id
    remove_column :projects, :created_by_id
  end
end
