#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'jira_lib/defaultDriver.rb'

class JiraInterface

  #TODO: read all these constants from a yml file
  ENDPOINT_URL = FUSEFORGE_URL + "/issues/rpc/soap/jirasoapservice-v2"
  #ENDPOINT_URL = "http://localhost:8080/rpc/soap/jirasoapservice-v2"
  PROJECT_ADMIN_GROUP_PERM = "admin"
  PROJECT_USER_GROUP_PERM = "members"
  PROJECT_ALL_PERM = "all"  
  
  MEMBERS = "all"
  LOGIN = 'forgeadmin'
  PASSWORD = 'forgeadmin'
  #LOGIN = 'jira'
  #PASSWORD = 'jira'

  ADMIN_GROUP_PERMISSIONS = {
   23 => :administer_projects,
   30 => :modify_reporter,
   16 => :delete_issues,
   32 => :manage_watcher_list,
   36 => :delete_all_comments,
   38 => :delete_all_attachments,
   43 => :delete_all_worklogs
  }

  USER_GROUP_PERMISSIONS = {

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

  UNASSIGNED_PERMISSIONS = {
    26 => :set_issue_security
  }

  def initialize
    @jira_soap_service = JiraSoapService.new(ENDPOINT_URL)

      if ENDPOINT_URL =~ /forge\.fusesource\./
      relm = "http://forge.fusesource.com/" 
      username = "fuseforge" 
      password = "gong6.afield" 
      @jira_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
    elsif ENDPOINT_URL =~ /forge\.fusesourcedev\./
      relm = "http://forge.fusesourcedev.com/" 
      username = "fuseforge" 
      password = "gong6.afield" 
      @jira_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
    end

    @ctx = login
  end
  
  def login
    @jira_soap_service.login(LOGIN, PASSWORD)
  end  
  
  #if private_project is true then make it a private project from non-private project
  #if private_project is false then make it a non-private project from private project  
  def update_project(project_key , private_project)
    
    proj_id = @jira_soap_service.getProjectByKey(@ctx,project_key).id
    project = @jira_soap_service.getProjectWithSchemesById(@ctx,proj_id)
    old_perm_scheme_name = project.permissionScheme.name
    len = old_perm_scheme_name.length
    iter = old_perm_scheme_name.slice(len-1,len)
    iter = iter.to_i + 1
    
    #check if the proj_short_name exists
    new_perm_scheme = @jira_soap_service.createPermissionScheme(@ctx, "#{project_key}-scheme"+iter.to_s,"Created through webservice")

    remuser = @jira_soap_service.getUser(@ctx,"forgeadmin")
    
    admin_grp = @jira_soap_service.getGroup(@ctx,"forge-#{project_key}-admins".downcase)
    user_grp =  @jira_soap_service.getGroup(@ctx,"forge-#{project_key}-members".downcase)
    forge_admin =  @jira_soap_service.getUser(@ctx,ApplicationHelper.get_forge_administrator.downcase)
    forge_users_grp = @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_jira_group)
    
        
    @jira_soap_service.getAllPermissions(@ctx).each do |perm| 
      if ADMIN_GROUP_PERMISSIONS.include?(perm.permission)
        @jira_soap_service.addPermissionTo(@ctx, new_perm_scheme, perm,admin_grp)
        @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_admin)
      elsif USER_GROUP_PERMISSIONS.include?(perm.permission)
        if private_project == true
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,user_grp)
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_admin)
        else 
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_users_grp)                      
        end
      end
    end

    
    project.permissionScheme = new_perm_scheme
    @jira_soap_service.updateProject(@ctx,project)
    @jira_soap_service.deletePermissionScheme(@ctx,old_perm_scheme_name)
    
  end
  
  def project_name_exists?(project_name)
    @jira_soap_service.getProjectsNoSchemes(@ctx).any? { |remote_project| remote_project.name == project_name }
  end

  def project_key_exists?(project_key)
    @jira_soap_service.getProjectsNoSchemes(@ctx).any? { |remote_project| remote_project.key == project_key }
  end

  def remove_project(project_id)
    @jira_soap_service.deleteProject(@ctx,project_id)
  end
  
  def is_project_name_key_unique?(project_name, project_key)
    
      projects = @jira_soap_service.getProjectsNoSchemes(@ctx) 
      
      projects.each do  |project|
      
        return true if project.name == project_name && project.key == project_key
      end    
  end

  def get_issues_for_project(project_id,issue_url,num_results=5)
    issues = @jira_soap_service.getIssuesFromTextSearchWithProject(@ctx,[project_id],"",num_results)
    arr_issues = []
    
    issues.each do |issue|
      hsh_issue = {:title=>issue.summary,:updated_at=>issue.updated,:url=>issue_url+'/'+issue.key}
      arr_issues << hsh_issue if issue.status.to_i != 6
    end
    arr_issues
  end
  
  def add_group_to_project(project_id, group_name,type='all')
     project = @jira_soap_service.getProjectByKey(@ctx,project_id)
#    #project_role = @jira_soap_service.getProjectWithSchemesById(@ctx,Integer("10183"))
#    project = @jira_soap_service.getProjectById(@ctx,project_id)
     group = @jira_soap_service.getGroup(@ctx,group_name)
    
     perm_schemes = @jira_soap_service.getPermissionSchemes(@ctx)
    
    perm_schemes.each do |perm_scheme|
                             
      if perm_scheme.name == "TestScheme"
      project.permissionScheme = perm_scheme  
        @jira_soap_service.updateProject(@ctx,project)
#        perm_scheme.permissionMappings.each do |perm| 
#          if ADMIN_GROUP_PERMISSIONS.include?(perm.permission.permission)
#            perm.remoteEntities << group
#          end
#      end
#      project.permissionScheme = perm_scheme
    end
    end  
  end

  def remove_group_from_project(project_id, group_name,type='all')
    true
  end

  
  def associate_groups(source_group,merge_group)
    
    src_group = @jira_soap_service.getGroup(@ctx,source_group)
    mrg_group = @jira_soap_service.getGroup(@ctx,merge_group)
    perm_schemes = @jira_soap_service.getPermissionSchemes(@ctx)
    
    perm_schemes.each do |perm_scheme|
      perm_scheme.permissionMappings.each do |perm_mapping|
        if perm_mapping.remoteEntities.each do | entity | 
          @jira_soap_service.addPermissionTo(@ctx,perm_scheme,perm_mapping,mrg_group) if entity && entity.name == src_group.name  
        end   
      end
      end
      
    end
  end
  
  
  #TODO: assign project category
  
  def create_proj_default_perm(project_name, proj_short_name,project_owner_id,issue_url,private_project=false)

    remuser = @jira_soap_service.getUser(@ctx,project_owner_id)
    
    admin_grp = @jira_soap_service.getGroup(@ctx,"forge-#{proj_short_name}-admins".downcase)
    user_grp =  @jira_soap_service.getGroup(@ctx,"forge-#{proj_short_name}-members".downcase)
    forge_admin =  @jira_soap_service.getUser(@ctx,ApplicationHelper.get_forge_administrator.downcase)
    #If you change the below group make sure you add the changed group to 
    #crowd application that connects to jira(currently called forgejira on crowd in source)
    #SEE STEP 1.3 in integration guide for more information
    #
    forge_users_grp = @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_jira_group)
    
    #check if the proj_short_name exists
    new_perm_scheme = @jira_soap_service.createPermissionScheme(@ctx, "#{proj_short_name}-scheme","Created through webservice")

    @jira_soap_service.getAllPermissions(@ctx).each do |perm| 
      if ADMIN_GROUP_PERMISSIONS.include?(perm.permission)
        @jira_soap_service.addPermissionTo(@ctx, new_perm_scheme, perm,admin_grp)
        @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_admin)
      elsif USER_GROUP_PERMISSIONS.include?(perm.permission)
        if private_project == true
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,user_grp)
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_admin)
        else 
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_users_grp)                      
        end
      end
    end
    @jira_soap_service.createProject(@ctx,proj_short_name, 
            project_name, "Created through JIRARPC",issue_url+proj_short_name , "forgeadmin",
     new_perm_scheme, nil, nil)
    logout(@ctx)    
 end

 
def logout(ctx)
  @jira_soap_service.logout(ctx)
end
end
