class PhpbbPost < ActiveRecord::Base
  RECENT_LIMIT = 5
  
  establish_connection "phpbb"
  set_table_name "phpbb_posts"
  set_primary_key "post_id"
  
  belongs_to :phpbb_forum, :class_name => "PhpbbForum", :foreign_key => "forum_id"
  belongs_to :phpbb_topic, :class_name => "PhpbbTopic", :foreign_key => "topic_id"

  named_scope :recent, :limit => RECENT_LIMIT, :order => 'post_time desc'
  

  def url
    "#{Forum::INTERNAL_URL}/viewtopic.php?f=#{forum_id}&t=#{topic_id}#p#{post_id}"    
  end  
end