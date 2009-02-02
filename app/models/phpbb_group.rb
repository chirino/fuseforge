class PhpbbGroup < ActiveRecord::Base
  establish_connection "phpbb"
  set_table_name "phpbb_groups"
  set_primary_key "group_id"
  
  has_one :project_group
  
  has_many :phpbb_user_groups, :class_name => "PhpbbUserGroup", :foreign_key => "group_id", :dependent => :destroy
end