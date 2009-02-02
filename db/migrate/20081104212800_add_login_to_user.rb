class AddLoginToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string
    remove_column :users, :name
    remove_column :users, :email
  end

  def self.down
    remove_column :users, :login
    add_column :users, :name, :string
    add_column :users, :email, :string
  end
end
