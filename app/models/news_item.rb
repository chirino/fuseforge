class NewsItem < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  named_scope :recent, :order => 'created_at desc', :limit => 5  
  named_scope :all, :order => 'created_at desc'
  
  validates_presence_of :title
  validates_associated :created_by, :on => :create
  validates_associated :updated_by
  
  def homepage_title
    self.title
  end
end
