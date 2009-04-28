if ActiveRecord::Base.configurations["phpbb"]
  
  require 'composite_primary_keys'

  class PhpbbUserGroup < ActiveRecord::Base
    establish_connection "phpbb"
    set_table_name "phpbb_user_group"
    set_primary_keys "group_id", "user_id"
  
    belongs_to :phpbb_group, :class_name => "PhpbbGroup", :foreign_key => "group_id"
    belongs_to :phpbb_user, :class_name => "PhpbbUser", :foreign_key => "user_id"
  
    def before_create
      self.user_pending = 0
    end
  end
  
end