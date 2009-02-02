class CreateWikis < ActiveRecord::Migration
  def self.up
    create_table :wikis do |t|
      t.integer :project_id
      t.boolean :is_active
      t.boolean :use_internal
      t.string :external_url

      t.timestamps
    end
  end

  def self.down
    drop_table :wikis
  end
end
