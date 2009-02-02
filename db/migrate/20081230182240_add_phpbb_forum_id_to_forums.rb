class AddPhpbbForumIdToForums < ActiveRecord::Migration
  def self.up
    add_column :forums, :phpbb_forum_id, :integer
  end

  def self.down
    remove_column :forums, :phpbb_forum_id
  end
end
