class CreateMailingLists < ActiveRecord::Migration
  def self.up
    create_table :mailing_lists do |t|
      t.integer :project_id
      t.string :name
      
      t.boolean :use_internal
      t.string :external_post_address
      t.string :external_subscribe_address
      t.string :external_unsubscribe_address
      
      t.string :internal_replyto      
    end
    
   add_index(:mailing_lists, [:project_id, :name], :unique => true)
    
    #
    # Add the default mailing lists to all the projects
    #
    Project.all.each do |project|
      project.send :add_default_mailing_lists
    end
    
  end

  def self.down
    remove_index :mailing_lists, :column => [:project_id, :name]
    drop_table :mailing_lists
  end
end