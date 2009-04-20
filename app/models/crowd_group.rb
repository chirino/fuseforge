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
  
  def self.confluence_user_group
    CrowdGroup.new "forge-confluence-users"
  end

  def self.company_employee_group
    CrowdGroup.new "iona-employee"
  end
  
  def self.jira_developer_group
    CrowdGroup.new "jira-fuseforge-developers"
  end

  def self.registered_user_group
    CrowdGroup.new "registered-users"
  end
  
end
