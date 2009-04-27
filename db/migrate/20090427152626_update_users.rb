class UpdateUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cached_at, :datetime
    change_column :users, :ssh_public_key, :text
  end

  def self.down
    remove_column :users, :cached_at
    change_column :users, :ssh_public_key, :string
  end
end
