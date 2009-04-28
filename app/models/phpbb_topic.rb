if ActiveRecord::Base.configurations["phpbb"]
  class PhpbbTopic < ActiveRecord::Base
    establish_connection "phpbb"
    set_table_name "phpbb_topics"
    set_primary_key "topic_id"
  
    belongs_to :phpbb_forum, :class_name => "PhpbbForum", :foreign_key => "forum_id"

    has_many :phpbb_posts, :class_name => "PhpbbPost", :foreign_key => "post_id"
  end
end