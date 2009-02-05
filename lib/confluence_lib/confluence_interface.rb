#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'confluence_lib/confluence_defaultDriver.rb'

class ConfluenceInterface

  #TODO: read all these constants from a yml file
  ENDPOINT_URL = FUSEFORGE_URL + "/wiki/rpc/soap-axis/confluenceservice-v1" #"http://www.ionadev.com/issues/rpc/soap/jirasoapservice-v2"
  #ENDPOINT_URL = "http://localhost:8080/rpc/soap-axis/confluenceservice-v1"
  
  MEMBERS = "all"
  #LOGIN = 'confluence'
  #PASSWORD = 'confluence'
  #LOGIN = 'sanjaymk'
  #PASSWORD = '1yajnas1'
  LOGIN = 'forgeadmin'
  PASSWORD = 'forgeadmin'
  def initialize
    @confluence_soap_service = ConfluenceSoapService.new(ENDPOINT_URL)

    if ENDPOINT_URL.include?('ionadev')
      relm = "http://www.ionadev.com/" 
      username = "iona" 
      password = "logicblaze" 
      @confluence_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
    elsif ENDPOINT_URL.include?('forge.fusesource')
      relm = "http://forge.fusesource.com/" 
      username = "fuseforge" 
      password = "gong6.afield" 
      @confluence_soap_service.options["protocol.http.basic_auth"] << [relm, username, password]    
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

  
  def create_space1(project_id, project_name,is_private)
    
  remote_space = @confluence_soap_service.getSpace(@ctx, "SPONE ")
  remote_space_groups = @confluence_soap_service.getSpaceGroups(@ctx)
  user_perm = @confluence_soap_service.getPermissionsForUser(@ctx,project_id,"sanjaymk")
  groups = @confluence_soap_service.getGroups(@ctx)
  user_groups = @confluence_soap_service.getUserGroups(@ctx,"sanjaymk")
  space_perms = @confluence_soap_service.getSpaceLevelPermissions(@ctx)
  
  #get Permissions that can be assigned
  #permissions = @confluence_soap_service.getPermissions(@ctx,project_id)
  space_perms.each do |perm|
    #TODO: remove the hard coding of forge-confluence-users
    @confluence_soap_service.addPermissionToSpace(@ctx,perm,"forge-confluence-users",project_id)
  end
  #remote_space_group = @confluence_soap_service.getSpaceGroup(@ctx,"forge-confluence-users")
#   space = RemoteSpace.new
#   space.name = project_name
#   space.key = project_id
#   space.spaceGroup = remote_space_group
#   space.description = "Confluence workspace"
#   #space.homePage = ""
#   space.url = ""
#   
#   @confluence_soap_service.addSpace(@ctx,space)             
  end

end
