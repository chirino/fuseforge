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

require 'net/http'
require 'uri'
require 'jira/jira'
require 'benchmark_http_requests'

class IssueTracker < ActiveRecord::Base
  JIRA_INTERNAL_URL = JIRA_URL + '/browse/'

  belongs_to :project
  
  def before_save
    self.external_url = '' if use_internal?
    project.deploy if use_internal_changed?
  end
  
  def before_destroy
    
    Jira.open(JIRA_CONFIG) do |jira|
      jira_project = jira.project_by_key key
      return true unless jira_project
      jira.remove_project(key)
    end

  rescue => error
    logger.error """ #{project.name} failed to delete JIRA project: #{error}\n#{error.backtrace.join("\n")}"""
  end

  def is_active?
    use_internal? or not external_url.blank?
  end
  
  
  def url
    use_internal? ? internal_url : external_url
  end

  def internal_url
    "#{JIRA_INTERNAL_URL}#{project.shortname}"
  end  

  def exists_internally?
    Jira.open(JIRA_CONFIG) do |jira|
      jira.project_key_exists?(self.project.shortname)
    end
  end  
  
  def create_internal
    return true if not use_internal?

    Jira.open(JIRA_CONFIG) do |jira|
      jira_project = jira.project_by_key(key)
      
      # No need to do deploy if not active and the jira project does not exist
      if !project.is_active? && jira_project==nil
        return true
      end
      
      permission_scheme = RemotePermissionScheme.new
      if( !project.is_active? )
        # the 'Forge Inactive Permission Scheme'
        permission_scheme.id=10113
      elsif( project.is_private )
        # the 'Forge Private Permission Scheme'
        permission_scheme.id=10112
      else
        # the 'Forge Public Permission Scheme'
        permission_scheme.id=10111
      end
      
      if jira_project==nil
        notification_scheme = jira.notification_schemes.detect {|scheme| scheme.name=='Default Notification Scheme'}
        jira_project = jira.create_project(key, "Forge: #{project.name}", project.description, nil, lead_admin_name, permission_scheme, notification_scheme, nil)
      else
        # Fully load all the project settings..
        jira_project = jira.project_with_schemes_by_id(jira_project.id)

        # Update it..
        jira_project.name = "Forge: #{project.name}"
        # jira_project.lead = lead_admin_name
        # jira_project.notificationScheme = notification_scheme
        jira_project.description = project.description
        jira_project.permissionScheme = permission_scheme
        jira.update_project(jira_project)
      end
      
      # Update the project roles.
      logger.info "updating project roles"
      jira.remove_all_role_actors_by_project(jira_project)
      jira.all_project_roles.each do |role|
        case role.name
        when 'Users'
        when 'Read-Only'
        when 'Developers'
          members = member_groups
          jira.add_actors_to_project_role(jira_project, role, members)
        when 'Administrators'
          admins = admin_groups
          jira.add_actors_to_project_role(jira_project, role, admins)
        end
      end
    end
    true
  end
  
  private 
  
  def key 
    project.shortname.upcase
  end
    
  def lead_admin_name
    lead = project.admin_groups.user_names.detect { true }
    lead = project.created_by unless lead
    return lead
  end
  
  def admin_groups
    groups = [ CrowdGroup.forge_admin_group.name ]
    project.admin_groups.each do |group|
        groups << group.name
    end
    groups
  end
  
  def member_groups
    groups = []
    project.member_groups.each do |group|
        groups << group.name
    end
    groups
  end  
  
  # def get_issues_for_project(project_id,issue_url,num_results=5)
  #   issues = @jira.getIssuesFromTextSearchWithProject(@token,[project_id],"",num_results)
  #   arr_issues = []
  #   
  #   issues.each do |issue|
  #     hsh_issue = {:title=>issue.summary,:updated_at=>issue.updated,:url=>issue_url+'/'+issue.key}
  #     arr_issues << hsh_issue if issue.status.to_i != 6
  #   end
  #   arr_issues
  # end
    
end
