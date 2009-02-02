class ProjectGroup < ActiveRecord::Base
  include CrowdGroupMixins
  
  DEFAULT_PREFIX = 'forge'
  DEFAULT_ADMIN_SUFFIX = "admins"
  DEFAULT_MEMBER_SUFFIX = "members"

  belongs_to :project
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  belongs_to :phpbb_group, :class_name => "PhpbbGroup", :foreign_key => "phpbb_group_id"
  
  after_create :add_to_crowd, :add_to_phpbb
  before_destroy :remove_from_crowd, :remove_from_phpbb

  def exists_in_crowd?
    Crowd.new.find_all_group_names.include?(name)
  end     

  def add_to_crowd
    return unless self.default?
    Crowd.new.add_group(self.name) unless exists_in_crowd?    
  end
  
  def add_to_phpbb
    self.phpbb_group = PhpbbGroup.create(:group_type => 1, :group_name => name)
    save
  end
  
  def remove_from_crowd
    return unless default?
    Crowd.new.delete_group!(name) if exists_in_crowd?

  # TODO:  Take this out after we figure out problem with removing groups.
  rescue SOAP::FaultError
  end

  def remove_from_phpbb
    phpbb_group.destroy unless phpbb_group.blank? 
  end
  
  def add_user(user)
    add_crowd_user(user)
    add_forum_user(user)
  end
  
  def remove_user(user)
    remove_crowd_user(user)
    remove_forum_user(user)
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
    phpbb_group.phpbb_user_groups.find_by_user_id(user.phpbb_user.user_id).destroy
    project.forum.phpbb_forum.purge_cache unless project.forum.blank?
  end  
  
  def default?
    false
  end
  
  def self.group_names
    self.all(:order => :name).collect { |x| x.name }
  end
end