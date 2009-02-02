class AddCreatedByIdUpdatedByIdToFeaturedProject < ActiveRecord::Migration
  def self.up
    add_column :featured_projects, :created_by_id, :integer
    add_column :featured_projects, :updated_by_id, :integer
  end

  def self.down
    remove_column :featured_projects, :updated_by_id
    remove_column :featured_projects, :created_by_id
  end
end
