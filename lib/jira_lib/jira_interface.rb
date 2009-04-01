#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'jira_lib/defaultDriver.rb'

class JiraInterface
  ENDPOINT_URL = JIRA_URL + "/issues/rpc/soap/jirasoapservice-v2"

  MEMBERS = "all"
  LOGIN = 'forgeadmin'
  PASSWORD = 'forgeadmin'

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

#      if ENDPOINT_URL =~ /forge\.fusesource\./
#      relm = "http://forge.fusesource.com/" 
#      username = "fuseforge" 
#      password = "gong6.afield" 
#      @jira_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
#    elsif ENDPOINT_URL =~ /forge\.fusesourcedev\./
#      relm = "http://forge.fusesourcedev.com/" 
#      username = "fuseforge" 
#      password = "gong6.afield" 
#      @jira_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
#    end

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

    # if the permission scheme is Default Permission Scheme(a scenario where the user  changed the permission
    # scheme using the JIRA UI), don't delete the default permission scheme, but go ahead and create another
    # permission scheme
    #
    @jira_soap_service.deletePermissionScheme(@ctx,old_perm_scheme_name) unless old_perm_scheme_name == \
     'Default Permission Scheme'
    
    new_perm_scheme = @jira_soap_service.createPermissionScheme(@ctx, "#{project_key}-scheme",
     "Permission scheme for #{project_key}")

    proj_groups = ApplicationHelper.get_project_groups(project_key)
    forge_admin =  @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_admins_group)
    forge_users_grp = @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_jira_group)


    assign_permissions_to_perm_scheme(new_perm_scheme,forge_admin,proj_groups,forge_users_grp,private_project)
    
    project.permissionScheme = new_perm_scheme
    @jira_soap_service.updateProject(@ctx,project)
    @jira_soap_service.logout(@ctx)
  end
  
  def assign_permissions_to_perm_scheme(new_perm_scheme, forge_admin, proj_groups, forge_users_grp,
   private_project)
    admin_grp = @jira_soap_service.getGroup(@ctx,proj_groups[:admins_grp].downcase)
    user_grp =  @jira_soap_service.getGroup(@ctx,proj_groups[:membrs_grp].downcase)
    
    @jira_soap_service.getAllPermissions(@ctx).each do |perm| 
      @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_admin)
      
      if ADMIN_GROUP_PERMISSIONS.include?(perm.permission)
        @jira_soap_service.addPermissionTo(@ctx, new_perm_scheme, perm,admin_grp)
      elsif USER_GROUP_PERMISSIONS.include?(perm.permission)
        if private_project == true
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,user_grp)
        else 
          @jira_soap_service.addPermissionTo(@ctx,new_perm_scheme,perm,forge_users_grp)                      
        end
      end
    end
  end
  
  def permission_scheme_exists?(perm_scheme_name)
    @jira_soap_service.getPermissionSchemes.any? { |s| s.name == perm_scheme_name }
  end  
  
  def create_public_perm_scheme(project)
    create_perm_scheme(project, false)
  end
  
  def create_private_perm_scheme(project)
    create_perm_scheme(project, true)
  end
      
  def create_perm_scheme(project, is_private)
    perm_scheme_name = is_private ? project.issue_tracker.private_scheme_name : \
     project.issue_tracker.public_scheme_name
    
    return if permission_scheme_exists?(perm_scheme_name)

    perm_scheme = @jira_soap_service.createPermissionScheme(@ctx, perm_scheme_name, project.description)
    forge_admin =  @jira_soap_service.getGroup(@ctx, ApplicationHelper.get_forge_admins_group)
    admin_group = @jira_soap_service.getGroup(@ctx, project.admin_groups.default.name.downcase)

    if is_private
      user_group =  @jira_soap_service.getGroup(@ctx, project.member_groups.default.name.downcase)
    else  
      user_group = @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_jira_group)
    end
    
    @jira_soap_service.getAllPermissions(@ctx).each do |perm| 
      @jira_soap_service.addPermissionTo(@ctx, perm_scheme, perm, forge_admin)
      @jira_soap_service.addPermissionTo(@ctx, perm_scheme, perm, admin_group) if \
       ADMIN_GROUP_PERMISSIONS.include?(perm.permission)
      @jira_soap_service.addPermissionTo(@ctx, perm_scheme, perm, user_group) if \
       USER_GROUP_PERMISSIONS.include?(perm.permission)                      
    end

    perm_scheme
  end
    
  def make_existing_project_private(project)
    set_project_perm_scheme(project, create_private_perm_scheme(project))
  end
  
  def make_existing_project_public(project)
    set_project_perm_scheme(project, create_public_perm_scheme(project))
  end
  
  def set_project_perm_scheme(project, perm_scheme)
    jira_project_id = @jira_soap_service.getProjectByKey(@ctx, project.shortname).id
    jira_project = @jira_soap_service.getProjectWithSchemesById(@ctx, jira_project_id)
    jira_project.permissionScheme = perm_scheme
    @jira_soap_service.updateProject(@ctx, jira_project)
    @jira_soap_service.logout(@ctx)
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
  
#  def is_project_name_key_unique?(project_name, project_key)
    
#      projects = @jira_soap_service.getProjectsNoSchemes(@ctx) 
      
#      projects.each do  |project|
      
#        return true if project.name == project_name && project.key == project_key
#      end    
#  end

  def get_issues_for_project(project_id,issue_url,num_results=5)
    issues = @jira_soap_service.getIssuesFromTextSearchWithProject(@ctx,[project_id],"",num_results)
    arr_issues = []
    
    issues.each do |issue|
      hsh_issue = {:title=>issue.summary,:updated_at=>issue.updated,:url=>issue_url+'/'+issue.key}
      arr_issues << hsh_issue if issue.status.to_i != 6
    end
    arr_issues
  end
  
  def add_groups_to_project(project_id, group_name,type='all')

    project = @jira_soap_service.getProjectByKey(@ctx,project_id)
    project = @jira_soap_service.getProjectWithSchemesById(@ctx,project.id)
    
    new_group = @jira_soap_service.getGroup(@ctx,group_name)
    
    perm_scheme = project.permissionScheme
    old_perm_scheme_name = perm_scheme.name
    admin_hash =  Hash.new
    user_hash =  Hash.new
    
    perm_scheme.permissionMappings.each do |perm|
    if ADMIN_GROUP_PERMISSIONS.include?(perm.permission.permission)
      entities = perm.remoteEntities
      if type == "ADMIN"  or type == "ALL"
        entities << new_group
      end
      admin_hash[perm.permission.permission] = entities
    elsif USER_GROUP_PERMISSIONS.include?(perm.permission.permission)
      entities = perm.remoteEntities
       if type == "USER" or type == "ALL"
        entities << new_group
      end
      user_hash[perm.permission.permission] = entities
    end
    end

    @jira_soap_service.deletePermissionScheme(@ctx,old_perm_scheme_name) unless old_perm_scheme_name == \
     'Default Permission Scheme'    
    new_perm_scheme = @jira_soap_service.createPermissionScheme(@ctx, "#{project_id}-scheme",
     "Permission scheme for #{project_id}")

    @jira_soap_service.getAllPermissions(@ctx).each do |perm| 
      if ADMIN_GROUP_PERMISSIONS.include?(perm.permission)
        admin_hash[perm.permission].each do |group| 
          @jira_soap_service.addPermissionTo(@ctx, new_perm_scheme, perm,group) 
        end
      elsif USER_GROUP_PERMISSIONS.include?(perm.permission)
        user_hash[perm.permission].each do |group| 
          @jira_soap_service.addPermissionTo(@ctx, new_perm_scheme, perm,group) 
        end
      end
    end
    
    project.permissionScheme = new_perm_scheme                          
    @jira_soap_service.updateProject(@ctx,project)
  end

#  def associate_groups(source_group,merge_group)
    
#    src_group = @jira_soap_service.getGroup(@ctx,source_group)
#    mrg_group = @jira_soap_service.getGroup(@ctx,merge_group)
#    perm_schemes = @jira_soap_service.getPermissionSchemes(@ctx)
    
#    perm_schemes.each do |perm_scheme|
#      perm_scheme.permissionMappings.each do |perm_mapping|
#        if perm_mapping.remoteEntities.each do | entity | 
#          @jira_soap_service.addPermissionTo(@ctx,perm_scheme,perm_mapping,mrg_group) if \
#           entity && entity.name == src_group.name  
#        end   
#      end
#      end
      
#    end
#  end
  
  
  #TODO: assign project category
  
  def old_create_proj_default_perm(project_name, proj_short_name, project_desc,project_owner_id,
   issue_url,private_project=false)

    forge_admin =  @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_admins_group)
    proj_groups = ApplicationHelper.get_project_groups(proj_short_name)
    
    
    #If you change the below group make sure you add the changed group to 
    #crowd application that connects to jira(currently called forgejira on crowd in source)
    #SEE STEP 1.3 in integration guide for more information
    #
    forge_users_grp = @jira_soap_service.getGroup(@ctx,ApplicationHelper.get_forge_jira_group)
    
    not_schemes = @jira_soap_service.getNotificationSchemes(@ctx)
    def_scheme = not_schemes.detect {|scheme| scheme.name=='Default Notification Scheme'}
    
    #check if the proj_short_name exists
    new_perm_scheme = @jira_soap_service.createPermissionScheme(@ctx, "#{proj_short_name}-scheme",project_desc)

    assign_permissions_to_perm_scheme(new_perm_scheme,forge_admin,proj_groups,forge_users_grp,private_project)
    
    @jira_soap_service.createProject(@ctx,proj_short_name, 
            project_name, project_desc,issue_url+proj_short_name , project_owner_id,
     new_perm_scheme, def_scheme, nil)
    logout(@ctx)    
  end

  def create_proj_default_perm(project)
    def_scheme = @jira_soap_service.getNotificationSchemes(@ctx).detect do |scheme| 
      scheme.name == 'Default Notification Scheme'
    end
    perm_scheme = project.is_private? ? create_private_perm_scheme(project) : create_public_perm_scheme(project)
    
    @jira_soap_service.createProject(@ctx, project.shortname, project.name, project.description, 
     IssueTracker::JIRA_URL+project.short_name, project.created_by.login, perm_scheme, def_scheme, nil)

    logout(@ctx)    
  end

  def logout(ctx)
    @jira_soap_service.logout(ctx)
  end
end
