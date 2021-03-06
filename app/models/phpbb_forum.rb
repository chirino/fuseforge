# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================

if ActiveRecord::Base.configurations["phpbb"]
  class PhpbbForum < ActiveRecord::Base
    FORUM_CACHE_PATH = ""
  
    establish_connection "phpbb"
    set_table_name "phpbb_forums"
    set_primary_key "forum_id"
  
    has_one :forum
  
    has_many :phpbb_acl_groups, :class_name => "PhpbbAclGroup", :foreign_key => "forum_id"
    has_many :phpbb_topics, :class_name => "PhpbbTopic", :foreign_key => "forum_id"
    has_many :phpbb_posts, :class_name => "PhpbbPost", :foreign_key => "forum_id"

    def before_create
      self.class.connection.execute("LOCK TABLES #{self.class.table_name} WRITE")     
    
      max_right_id = self.class.maximum('right_id')
    
  		self.left_id = max_right_id + 1
  		self.right_id = max_right_id + 2
  #		forum_password = '$H$9gGVKhAKArfDs32dfCsdJZcL1XnnIV/'
  #		forum_image = 'admin'
  		self.forum_type = 1
  		self.display_on_index = 0
  		self.enable_icons = 0
  		self.prune_days = 7
  		self.prune_viewed = 7
  		self.prune_freq = 1
  	end  
	
  	def after_create
  	   self.class.connection.execute("UNLOCK TABLES") 
  	end

    def lock
      return true if forum_status == 1
    
      self.forum_status = 1
      save
      purge_cache
    end
  
    def unlock
      return true if forum_status == 0
    
      self.forum_status = 0
      save
      purge_cache
    end
  
    def locked?
      forum_status == 1 ? true : false
    end
  
    def unlocked?
      not locked?
    end
  
    def recreate_group_rights(make_private)
      phpbb_acl_groups.destroy_all
      create_group_rights(make_private)
    end
  
    def create_group_rights(make_private=self.forum.project.is_private?)
      create_site_admin_rights
      create_project_admin_rights
      create_project_member_rights
      create_registered_user_rights(make_private)
      create_bot_rights(make_private)
      create_guest_rights(make_private)
    end
  
    def purge_cache
      system("sudo -u #{FORUM_CONFIG[:user]} rm #{FORUM_CONFIG[:path]}/cache/*")  
      system("sudo -u #{FORUM_CONFIG[:user]} echo '#{htaccess_file_contents}' > #{FORUM_CONFIG[:path]}/cache/.htaccess")
    end
  
    private
  
    def create_site_admin_rights
      phpbb_acl_groups.create(:group_id => 4, :auth_option_id => 0, :auth_role_id => PhpbbAclRole::FORUM_POLLS, :auth_setting => 0)
      phpbb_acl_groups.create(:group_id => 5, :auth_option_id => 0, :auth_role_id => PhpbbAclRole::FORUM_FULL, :auth_setting => 0)
      phpbb_acl_groups.create(:group_id => 5, :auth_option_id => 0, :auth_role_id => PhpbbAclRole::MOD_FULL, :auth_setting => 0)
    end
  
    def create_project_admin_rights	  
      phpbb_acl_groups.create(:group_id => forum.project.admin_groups.default.phpbb_group.group_id, :auth_option_id => 0, 
       :auth_role_id => PhpbbAclRole::FORUM_FULL, :auth_setting => 0)
    end
  
    def create_project_member_rights    
      phpbb_acl_groups.create(:group_id => forum.project.member_groups.default.phpbb_group.group_id, :auth_option_id => 0, 
       :auth_role_id => PhpbbAclRole::FORUM_STANDARD, :auth_setting => 0)
    end
  
    def create_registered_user_rights(make_private)      
      auth_role_id = make_private ? PhpbbAclRole::FORUM_NOACCESS : PhpbbAclRole::FORUM_READONLY
      phpbb_acl_groups.create(:group_id => 2, :auth_option_id => 0, :auth_role_id => auth_role_id, :auth_setting => 0)
      phpbb_acl_groups.create(:group_id => 3, :auth_option_id => 0, :auth_role_id => auth_role_id, :auth_setting => 0)
    end

    def create_bot_rights(make_private)
      if make_private
        phpbb_acl_groups.create(:group_id => 6, :auth_option_id => 0, :auth_role_id => PhpbbAclRole::FORUM_NOACCESS, :auth_setting => 0)
      else
        phpbb_acl_groups.create(:group_id => 6, :auth_option_id => 0, :auth_role_id => PhpbbAclRole::FORUM_READONLY, :auth_setting => 0)
        phpbb_acl_groups.create(:group_id => 6, :auth_option_id => 0, :auth_role_id => PhpbbAclRole::FORUM_BOT, :auth_setting => 0)
      end
    end

    def create_guest_rights(make_private)
      auth_role_id = make_private ? PhpbbAclRole::FORUM_NOACCESS : PhpbbAclRole::FORUM_READONLY
      phpbb_acl_groups.create(:group_id => 1, :auth_option_id => 0, :auth_role_id => auth_role_id, :auth_setting => 0)
    end
  
    def htaccess_file_contents
  <<eos
<Files *>
	Order Allow,Deny
	Deny from All
</Files>
eos
    end
  end
end