class Project < ActiveRecord::Base
  RECENT_PROJECTS_LIMIT = 5
  MOST_ACTIVE_PROJECTS_LIMIT = 5
  PROJECTS_MOST_DOWNLOADED_LIMIT = 5
  
  acts_as_taggable_on :tags
  
  has_one :featured_project, :dependent => :destroy
  has_one :issue_tracker, :dependent => :destroy
  has_one :repository, :dependent => :destroy
  has_one :web_dav_location, :dependent => :destroy
  has_one :forum, :dependent => :destroy
  has_one :wiki, :dependent => :destroy
  
  has_many :news_items, :class_name => "ProjectNewsItem", :dependent => :destroy
  has_many :prospective_members, :class_name => "ProspectiveProjectMember", :dependent => :destroy
  
  has_many :groups, :class_name => "ProjectGroup", :dependent => :destroy do
    def users
      all.collect { |x| x.users }.flatten.uniq
    end
  end
  
  has_many :admin_groups, :class_name => "ProjectAdminGroup" do
    def default
      find_by_name(proxy_owner.default_admin_group_name)
    end
      
    def users
      all.collect { |x| x.users }.flatten.uniq
    end
    
    def group_names
      all.collect { |x| x.name }
    end  
  end
  
  has_many :member_groups, :class_name => "ProjectMemberGroup" do
    def default
      find_by_name(proxy_owner.default_member_group_name)
    end
      
    def users
      all.collect { |x| x.users }.flatten.uniq
    end

    def group_names
      all.collect { |x| x.name }
    end  
  end
  
  belongs_to :status, :class_name => "ProjectStatus", :foreign_key => "project_status_id"
  belongs_to :maturity, :class_name => "ProjectMaturity", :foreign_key => "project_maturity_id"
  belongs_to :category, :class_name => "ProjectCategory", :foreign_key => "project_category_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  has_attached_file :image, 
    :url => "/:class/:id/:attachment/:style.:extension",
    :path => ":rails_root/assets/:class/:attachment/:id/:style_:basename.:extension",      
    :default_url => "/:class/:attachment/missing_:style.png",
    :styles => { :medium => "160x160", :thumb => "70x70" }
  
  named_scope :public, :conditions => { :is_private => false }
  named_scope :active, lambda { { :conditions => ['project_status_id = ?', ProjectStatus.active.id] } }
  named_scope :inactive, lambda { { :conditions => ['project_status_id = ?', ProjectStatus.inactive.id] } }
  named_scope :unapproved, lambda { { :conditions => ['project_status_id = ?', ProjectStatus.unapproved.id] } }
  named_scope :approved, lambda { { :conditions => ['project_status_id != ?', ProjectStatus.unapproved.id] } }  
  named_scope :recent, :limit => RECENT_PROJECTS_LIMIT, :order => 'created_at desc'

  validates_presence_of :name, :shortname, :description, :status, :maturity, :category
  
  validates_uniqueness_of :name, :shortname
  validates_format_of :shortname, :with => /\A([A-Z0-9]+)\Z/, :allow_blank => true
  
  validates_associated :status, :maturity, :updated_by
  validates_associated :created_by, :on => :create
  
  validates_length_of :name, :minimum => 3
  validates_length_of :shortname, :within => 3..16
  
  validates_acceptance_of   :terms_and_conditions, :if => :allow_terms_and_conditions_validation?, :on => :create, 
   :message => 'must be checked'
  
  def before_validation_on_create
    self.status = ProjectStatus.unapproved
  end
  
  def before_update
    featured_project.destroy if is_private? and not featured_project.blank?
  end
  
  def before_create
    @accepted_terms_at = Time.now if @terms_and_conditions == '1'
  end
    
  def after_create
    init_groups
    Notifier.deliver_project_creation_notification(self)
  end
  
  def name=(value)
    forum.change_name(value) if (value != read_attribute(:name)) and not new_record?
    write_attribute(:name, value)
  end  
  
  def description=(value)
    forum.change_description(value) if (value != read_attribute(:description)) and not new_record?
    write_attribute(:description, value)
  end  
  
  def is_private=(value)
    bool_value = value == "1" ? true : false
    
    if (bool_value != read_attribute(:is_private)) and not new_record?
      
      confluence_interface = ConfluenceInterface.new
      jira_interface = JiraInterface.new
      
      #repository.reset_perm_file(bool_value)  
      #forum.reset_permissions(bool_value)

      arr_groups = Array.new
      arr_groups << "forge-#{self.shortname}-admins"
      arr_groups << "forge-#{self.shortname}-members"
      
      if bool_value == true
        #make it a private project from non-private project
        jira_interface.update_project(self.shortname, bool_value) 
      else
        #make it a non-private project from private project
        jira_interface.update_project(self.shortname, bool_value) 
      end

      
      confluence_interface.login
      if bool_value == true
        confluence_interface.add_remove_groups_to_space(self.shortname, 
                arr_groups,ApplicationHelper.get_default_confluence_group)
      else
        confluence_interface.add_remove_groups_to_space(self.shortname, ApplicationHelper.get_default_confluence_group, 
                                          arr_groups)
      end
        confluence_interface.logout
    end  
    
    write_attribute(:is_private, value)
  end  
  
  def accepted_terms?
    not @accepted_terms_at.blank?
  end

  # Make sure shortname cannot be changed once it is set.
  def shortname=(value)
    write_attribute(:shortname, value) if read_attribute(:shortname).blank?
  end  
  
  def approve
    init_components
    self.status = ProjectStatus.active
    save
    Notifier.deliver_project_approval_notification(self)
  end  

  def administrators
    admin_groups.users
  end
  
  def find_administrator_by_user_id(user_id)
    user = User.find(user_id)
    administrators.include?(user) ? user : nil
  end
  
  def members
    member_groups.users
  end
  
  def find_member_by_user_id(user_id)
    user = User.find(user_id)
    members.include?(user) ? user : nil
  end
  
  def users
    groups.users
  end
  
  def approved?
    status != ProjectStatus.unapproved
  end
    
  def add_administrator(user)
    admin_groups.default.add_user(user)
  end
    
  def remove_administrator(user)
    admin_groups.default.remove_user(user)
  end

  def add_member(user)
    member_groups.default.add_user(user)
  end
    
  def remove_member(user)
    member_groups.default.remove_user(user)
  end

  def default_admin_group_name
    @default_admin_group_name ||=  "#{ProjectGroup::DEFAULT_PREFIX}-#{shortname.downcase}-#{ProjectGroup::DEFAULT_ADMIN_SUFFIX}"
  end
  
  def default_member_group_name
    @default_member_group_name ||= "#{ProjectGroup::DEFAULT_PREFIX}-#{shortname.downcase}-#{ProjectGroup::DEFAULT_MEMBER_SUFFIX}"
  end  
  
  def downloads
    self.wiki.wiki_pages.collect do |wiki_page| 
      wiki_page.attachments.include_in_project_homepage_download_stats.collect { |attachment| attachment.downloads }
    end.flatten
  end
  
  def self.find_unapproved_by_id(project_id)
    self.find(:first, :conditions => ['id = ? AND project_status_id = ?', project_id, ProjectStatus.unapproved.id])
  end 
  
  def self.unfeatured
    self.public.approved - FeaturedProject.projects
  end
  
  def self.unfeatured_options_for_select
    self.unfeatured.collect { |x| [x.name, x.id] }
  end
  
  def self.most_active_this_week
    self.public.approved.sort { |a, b| b.repository.activity_this_week <=> a.repository.activity_this_week }[0...MOST_ACTIVE_PROJECTS_LIMIT]
  end
    
  def self.most_downloaded
    self.public.approved.sort { |a, b| b.repository.downloads <=> a.repository.downloads }[0...PROJECTS_MOST_DOWNLOADED_LIMIT]
  end
    
  private
  
  def init_groups
    admin_groups << ProjectAdminGroup.new(:name => default_admin_group_name)
    add_administrator(created_by)
    member_groups << ProjectMemberGroup.new(:name => default_member_group_name)
    add_member(created_by)
  end
  
  def init_components
    issue_tracker.create_internal
    wiki.create_internal
    forum.create_internal 
    repository.create_internal 
    web_dav_location.create_internal
  end  
  
  def allow_terms_and_conditions_validation?
    @accepted_terms_at.blank?
  end
end
