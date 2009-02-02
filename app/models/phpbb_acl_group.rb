require 'composite_primary_keys'

class PhpbbAclGroup < ActiveRecord::Base
  establish_connection "phpbb"
  set_table_name "phpbb_acl_groups"
  set_primary_keys "group_id", "forum_id"
  
  belongs_to :phpbb_forum, :class_name => "PhpbbForum", :foreign_key => "forum_id"

end