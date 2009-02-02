class ProjectNewsItem < ActiveRecord::Base
  RECENT_LIMIT = 5

  belongs_to :project
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  named_scope :recent, :order => 'created_at desc', :limit => RECENT_LIMIT  

  named_scope :recent_excluding_private, :conditions => ['projects.is_private = ?', false ], :include => :project, 
                       :order => 'project_news_items.created_at desc', :limit => 5  
  
  validates_presence_of :title, :project
  validates_associated :project, :updated_by
  validates_associated :created_by, :on => :create
  
  def homepage_title
    "#{project.name}: #{title}"
  end
end
