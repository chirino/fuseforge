class CreateDownloadRequests < ActiveRecord::Migration
  def self.up
    create_table :download_requests do |t|
      t.string :url
      t.string :description
      t.integer :created_by_id
      t.integer :project_id

      t.timestamps
    end  end

  def self.down
    drop_table :download_requests
  end
end
