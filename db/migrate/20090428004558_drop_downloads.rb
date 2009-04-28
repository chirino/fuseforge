class DropDownloads < ActiveRecord::Migration
  def self.up
    drop_table :download_requests
    drop_table :downloads
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted download tables"
  end
end
