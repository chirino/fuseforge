class AddPhpbbUserIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phpbb_user_id, :integer
  end

  def self.down
    remove_column :users, :phpbb_user_id
  end
end
