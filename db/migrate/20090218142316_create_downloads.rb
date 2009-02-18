class Downloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.string :url
      t.string :description
      t.integer :project_id

      t.timestamps
    end  
  end

  def self.down
    drop_table :downloads
  end
end
