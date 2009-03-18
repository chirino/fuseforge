class AddOtherLicenseUrlToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :other_license_url, :string
  end

  def self.down
    remove_column :projects, :other_license_url
  end
end
