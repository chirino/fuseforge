class AddSshKeyAndCrowdTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :crowd_token, :string
    add_column :users, :ssh_public_key, :string
  end

  def self.down
    remove_column :users, :crowd_token
    remove_column :users, :ssh_public_key
  end
end
