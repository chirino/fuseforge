#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'jira/defaultDriver.rb'

class Jira

	def group_role_actor_type
	  "atlassian-group-role-actor"
  end

	def user_role_actor_type
    "atlassian-user-role-actor"
  end

  def admin_group_permissions 
    {
      23 => :administer_projects,
      30 => :modify_reporter,
      16 => :delete_issues,
      32 => :manage_watcher_list,
      36 => :delete_all_comments,
      38 => :delete_all_attachments,
      43 => :delete_all_worklogs
    }
  end

  def user_group_permissions 
    {
      29 => :view_version_control,
      10 => :browse_projects, 
      11 => :create_issues,
      12 => :edit_issues,
      28 => :schedule_issues,
      25 => :move_issues,
      13 => :assign_issues,
      17 => :assignable_user, 
      14 => :resolve_issues,
      18 => :close_issues,
      21 => :link_issues,
      31 => :view_voters_and_watchers,
      15 => :add_comments,
      34 => :edit_all_comments,
      35 => :edit_own_comments,
      37 => :delete_own_comments,
      19 => :create_attachments,
      39 => :delete_own_attachments,
      20 => :work_on_issues,
      40 => :edit_own_worklogs,
      41 => :edit_all_worklogs,
      42 => :delete_own_worklogs
    }
  end

  def unassigned_permissions 
    {
      26 => :set_issue_security
    }
  end

  def initialize(config)
    @config = config
    @jira = JiraSoapService.new(@config[:url]+ "/rpc/soap/jirasoapservice-v2")
    # @jira.options["protocol.http.basic_auth"] << [relm, username, password]    
    @jira.options["protocol.http.basic_auth"] << @config[:basic_auth] if @config[:basic_auth]
    @token = @jira.login(@config[:login], @config[:password])    
  end

  def self.open(config, &block)
    rc = Jira.new(config)
    if( block ) 
      begin
        return block.call(rc)
      ensure
        rc.close
      end
    else
      return rc
    end
  end
  
  def close
    @jira.logout(@token)
  end  

  def project_name_exists?(name)
    @jira.getProjectsNoSchemes(@token).any? { |remote_project| remote_project.name == name }
  end

  def project_key_exists?(key)
    @jira.getProjectsNoSchemes(@token).any? { |remote_project| remote_project.key == key }
  end
  
  def notification_schemes
    @jira.getNotificationSchemes(@token)
  end

  def create_permission_scheme(name, description)
    @jira.createPermissionScheme(@token, name, description)
  end
  
  def group(name)
    @jira.getGroup(@token,name)
  end

  def all_permissions
    @jira.getAllPermissions(@token)
  end

  def all_permission_schemes
    @jira.getPermissionSchemes(@token) 
  end
  
  def add_permission_to(perm_scheme, perm, subject)
    @jira.addPermissionTo(@token, perm_scheme, perm, subject)
  end

  def create_project(key, name, description, url, owner, permission_scheme=nil, notification_scheme=nil, security_scheme=nil )
    @jira.createProject(@token, key, name, description, url, owner, permission_scheme, notification_scheme, security_scheme)
  end
  
  def project_by_key(key)
    @jira.getProjectByKey(@token,key)
  rescue RemoteException=>error
    return nil
  rescue
      
  end

  def project_with_schemes_by_id(id)
    @jira.getProjectWithSchemesById(@token,id)
  rescue RemoteException=>error
    return nil
  end

  def delete_permission_scheme(name)
    @jira.deletePermissionScheme(@token,name)
  end

  def update_project(project)
    @jira.updateProject(@token,project)
  end

  def remove_all_role_actors_by_project(project)
    @jira.removeAllRoleActorsByProject(@token, project) 
  end
  
  def all_project_roles
    @jira.getProjectRoles(@token) 
  end

  def add_actors_to_project_role(project, project_role, actors, actor_type=group_role_actor_type) 
    actors = ArrayOf_xsd_string.new actors unless actors.class==ArrayOf_xsd_string
    @jira.addActorsToProjectRole(@token, actors, project_role, project, actor_type) 
  end
  
end
