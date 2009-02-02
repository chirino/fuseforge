class CreateIssueTrackers < ActiveRecord::Migration
  def self.up
    create_table :issue_trackers do |t|
      t.integer :project_id
      t.boolean :active
      t.boolean :use_internal
      t.string :external_url

      t.timestamps
    end
  end

  def self.down
    drop_table :issue_trackers
  end
end
