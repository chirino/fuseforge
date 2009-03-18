class AddLicenseFieldsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :license_id, :integer

    create_table :project_licenses do |t|
      t.string :name
      t.text :description
      t.string :url
      t.boolean :is_active

      t.timestamps
    end
  end

  def self.down
    remove_column :projects, :license_id

    drop_table :project_licenses
  end
end
