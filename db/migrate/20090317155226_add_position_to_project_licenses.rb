class AddPositionToProjectLicenses < ActiveRecord::Migration
  def self.up
    add_column :project_licenses, :position, :integer
  end

  def self.down
    remove_column :project_licenses, :position
  end
end
