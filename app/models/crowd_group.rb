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

class CrowdGroup
  include CrowdGroupMixins
  
  attr_reader :name
  
  def initialize(name) 
    @name = name;
  end
  
  def self.non_forge_group_names
    Crowd.new.find_all_group_names.reject { |x| x =~ /^#{ProjectGroup::DEFAULT_PREFIX.downcase}-/ }
  end

  def add_user(user)
    add_crowd_user(user)
  end
  
  def remove_user(user)
    remove_crowd_user(user)
  end
  
  def self.forge_admin_group
    CrowdGroup.new "forge-admins"
  end

  def self.company_employee_group
    CrowdGroup.new "iona-employee"
  end

  def self.forge_icla_group
    CrowdGroup.new "forge-icla"
  end

  def self.registered_user_group
    CrowdGroup.new "registered-users"
  end
  
  def self.confluence_user_group
    CrowdGroup.new "forge-confluence-users"
  end

  def self.jira_developer_group
    CrowdGroup.new "jira-fuseforge-developers"
  end

  
end
