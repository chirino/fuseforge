class CreateWebDavLocations < ActiveRecord::Migration
  def self.up
    create_table :web_dav_locations do |t|
      t.integer :project_id
      t.boolean :is_active
      t.boolean :use_internal
      t.string :external_url

      t.timestamps
    end  
  end

  def self.down
    drop_table :web_dav_locations
  end
end
