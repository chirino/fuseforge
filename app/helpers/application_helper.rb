# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

#  INTERNAL_HOST = ((RAILS_ENV == 'development') or (Socket.gethostname == 'domU-12-31-39-00-4E-57')) ? 'http://www.ionadev.com/' : \
#                   'http://forge.fusesource.com/' 
  
  #IMPORTANT:  If you change this group you should also create the below renamed/changed group into crowd
  #and add it as one of the groups that you can be in to authenticate into crowd.
  #STEP 1.3 in the confluence-crowd integration
  #
  DEFAULT_CONFLUENCE_GROUP = "forge-confluence-users"
  FORGE_ADMINISTRATOR = "forgeadmin"
  FORGE_JIRA_GROUP    = "jira-fuseforge-developers"
    
  def ApplicationHelper.get_internal_host
    FUSEFORGE_URL + "/"
  end

  def ApplicationHelper.get_default_confluence_group
    DEFAULT_CONFLUENCE_GROUP
  end

  def ApplicationHelper.get_default_confluence_group
    DEFAULT_CONFLUENCE_GROUP
  end

  def ApplicationHelper.get_forge_administrator
    FORGE_ADMINISTRATOR
  end

  def ApplicationHelper.get_forge_jira_group
    FORGE_JIRA_GROUP
  end
  
  def ApplicationHelper.get_project_groups(project_sname)
      hsh_groups = Hash.new
      hsh_groups[:admins_grp] = "forge-#{project_sname}-admins".downcase
      hsh_groups[:membrs_grp] = "forge-#{project_sname}-members".downcase
      hsh_groups
  end

  
end
