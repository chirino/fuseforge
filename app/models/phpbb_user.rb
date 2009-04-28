if ActiveRecord::Base.configurations["phpbb"]
  
  class PhpbbUser < ActiveRecord::Base
    establish_connection "phpbb"
    set_table_name "phpbb_users"
    set_primary_key "user_id"
  
    has_one :fuseforge_user, :class_name => "User", :foreign_key => "phpbb_user_id"
    has_many :phpbb_user_groups, :class_name => "PhpbbUserGroup", :foreign_key => "user_id", :dependent => :destroy
  end
  
end