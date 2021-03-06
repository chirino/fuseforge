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

class ProjectGroup < ActiveRecord::Base
  include CrowdGroupMixins
  
  DEFAULT_PREFIX = 'forge'
  DEFAULT_ADMIN_SUFFIX = "admins"
  DEFAULT_MEMBER_SUFFIX = "members"

  belongs_to :project
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  after_create :add_to_crowd
  before_destroy :remove_from_crowd

  def self.group_names
    self.all(:order => :name).collect { |x| x.name }
  end

  def exists_in_crowd?
    Crowd.new.find_all_group_names.include?(name)
  end     

  def add_to_crowd
    return unless self.default?
    Crowd.new.add_group(self.name) unless exists_in_crowd?    
  end
  
  def remove_from_crowd
    return unless default?
#    Crowd.new.delete_group!(name) if exists_in_crowd?
  # TODO:  Take this out after we figure out problem with removing groups.
  rescue SOAP::FaultError
  end

  def add_user(login)
    add_crowd_user(login)
    project.deploy
  end
  
  def remove_user(login)
    remove_crowd_user(login)
    project.deploy
  end
  
  def contains_user?(login)
    user_names.index(login)!=nil
  end
    
  def default?
    false
  end
  
end

#
# If the phpbb database is configured, then update the Forum model 
# to allow internal phpbb3 forums.
#
if ActiveRecord::Base.configurations["phpbb"]
  class ProjectGroup
    ActiveRecord::Base.belongs_to :phpbb_group, :class_name => "PhpbbGroup", :foreign_key => "phpbb_group_id"
    
    #
    # Hooks into the ProjectGroup impl
    #
    ActiveRecord::Base.after_create :add_to_phpbb
    ActiveRecord::Base.before_destroy :remove_from_phpbb

    def add_user(user)
      add_crowd_user(user)
      add_forum_user(user)
    end
  
    def remove_user(user)
      remove_crowd_user(user)
      remove_forum_user(user)
    end    

    #
    # Implemenation helpers.
    #

    private
    def add_to_phpbb
      self.phpbb_group = PhpbbGroup.create(:group_type => 1, :group_name => name)
      save
    end
  
    def remove_from_phpbb
      phpbb_group.destroy unless phpbb_group.blank? 
    end
  
    def add_forum_user(user)
      if user.phpbb_user.blank?
        if phpbb_user = PhpbbUser.find_by_username(user.login)
          user.phpbb_user = phpbb_user  
        else
          user.phpbb_user = PhpbbUser.create(:group_id => 2, :username => user.login, :username_clean => user.login,
           :user_password => '$H$9/zSBnbst5iCLLKJBWgp7pfxQMfTnB/', :user_email => user.email, :user_lang => 'en', :user_style => 1,
           :user_colour => '9E8DA7')
        end 
        user.save
      end 
      phpbb_group.phpbb_user_groups.create(:phpbb_user => user.phpbb_user)
    end  
  
    def remove_forum_user(user)
      unless user.phpbb_user.user_id.blank?
        phpbb_group.phpbb_user_groups.find_by_user_id(user.phpbb_user.user_id).destroy
        project.forum.phpbb_forum.purge_cache unless project.forum.blank?
      end
    end  
  
  end
end