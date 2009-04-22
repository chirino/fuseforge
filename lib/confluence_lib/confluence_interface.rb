#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'confluence_lib/confluence_defaultDriver.rb'

class ConfluenceInterface
  
  ENDPOINT_URL = CONFLUENCE_CONFIG[:url] + "/rpc/soap-axis/confluenceservice-v1"
  LOGIN = CONFLUENCE_CONFIG[:login]
  PASSWORD = CONFLUENCE_CONFIG[:password]
  
  def initialize
    @confluence_soap_service = ConfluenceSoapService.new(ENDPOINT_URL)

    if ENDPOINT_URL =~ /fusesource\.com/
      relm = "http://fusesource.com/forge/"
      username = "fuseforge" 
      password = "gong6.afield" 
      @confluence_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
    elsif ENDPOINT_URL =~ /fusesourcedev\./
      relm = "http://fusesourcedev.com/" 
      username = "fuseforge" 
      password = "gong6.afield" 
#      @confluence_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
    end
  end
  
  def login
    @ctx = @confluence_soap_service.login(LOGIN, PASSWORD)
  end  

  def get_default_groups_from_shortname(proj_sname)
    groups = []
    groups << "forge-#{:proj_sname}-admins"
    groups << "forge-#{:proj_sname}-members"
  end
  
  def remove_space(project_sname)
    @confluence_soap_service.removeSpace(@ctx,project_sname)
  end

  def reset_space_perm(project_sname,private_val)
  
   proj_grps = ApplicationHelper.get_project_groups(project_sname)
   proj_grps[:forge_admin_group] = ApplicationHelper.get_forge_admins_group   
    
   if private_val == true
     add_remove_groups_to_space(project_sname,proj_grps.values,ApplicationHelper.get_default_confluence_group)
     #remove anonymous access
     @confluence_soap_service.removeAnonymousPermissionFromSpace(@ctx,"VIEWSPACE",project_sname)
   else   
     add_remove_groups_to_space(project_sname,ApplicationHelper.get_default_confluence_group,proj_grps.values)
     @confluence_soap_service.addAnonymousPermissionToSpace(@ctx,"VIEWSPACE",project_sname)
   end
    
  end
  
  def get_latest_for_space(project_sname, max_results=10)

    search_results = @confluence_soap_service.getPages(@ctx,project_sname)
    results = []
    desc_search_res = search_results.reverse
    desc_search_res.each do |page|
      
      result = {:title => page.title,:url => page.url}
      results << result
    end
    results
  end

  def space_exists?(project_sname)
    begin
      space = @confluence_soap_service.getSpace(@ctx,project_sname)
    rescue
      # WARNING:  This API throws an exception if the logged in user doesn't have permission to 
      # view the space
      # So, it is important that the person logged in with the @ctx SHOULD be an administrator who
      #can see all spaces.  So, if this API throws an exception the only reason is that the space doesn't
      #exist.  
      #
      return false
    end
    true
  end
  
  def modify_space(project_sname,project_name,project_desc,add_group_name,remove_group_name)
    
   remote_space = @confluence_soap_service.getSpace(@ctx, project_sname) 
   remote_space.name = "TSTSPACE"
    
    @confluence_soap_service.storeSpace(@ctx,remote_space)
    add_remove_group_to_space(project_sname,add_group_name,remove_group_name) if (add_group_name or remove_group_name)
    #logout(@ctx)
  end
      
  
  def add_remove_groups_to_space(project_sname,add_group_names,remove_group_names)
    
    space_perms = @confluence_soap_service.getSpaceLevelPermissions(@ctx)
    
    if add_group_names
      add_group_names.each do |group|
        space_perms.each do |perm|
            @confluence_soap_service.addPermissionToSpace(@ctx,perm,group.downcase,project_sname)
        end
      end
    end
    
    if remove_group_names
      remove_group_names.each do |group|
        @confluence_soap_service.removeAllPermissionsForGroup(@ctx,group.downcase)
      end
    end
  end
  
  def create_space(project_sname, project_name,project_description,wiki_url,is_private=false)
   
   #remote_space = @confluence_soap_service.getSpace(@ctx, "SPONE ")    
   space = RemoteSpace.new
   space.name = project_name
   space.key = project_sname
   space.description = project_description
   space.url = wiki_url+ "#{project_sname}/Home"
   
   @confluence_soap_service.addSpace(@ctx,space)             

    space_perms = @confluence_soap_service.getSpaceLevelPermissions(@ctx)
    
    space_perms.each do |perm|
      if is_private==true
        @confluence_soap_service.addPermissionToSpace(@ctx,perm,"forge-#{project_sname}-admins".downcase,project_sname)
        @confluence_soap_service.addPermissionToSpace(@ctx,perm,"forge-#{project_sname}-members".downcase,project_sname)
        @confluence_soap_service.addPermissionToSpace(@ctx,perm,ApplicationHelper.get_forge_admins_group.downcase,project_sname)
      else
        @confluence_soap_service.addPermissionToSpace(@ctx,perm,ApplicationHelper.get_default_confluence_group,project_sname)
        if perm=="VIEWSPACE"
          @confluence_soap_service.addAnonymousPermissionToSpace(@ctx,perm,project_sname) 
        end
      end
      
    end
   #logout(@ctx)
  end

  def logout
    @confluence_soap_service.logout(@ctx)
  end

end
