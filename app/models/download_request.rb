class DownloadRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  
  validates_presence_of :description, :url, :project
  validates_associated :project
  validates_associated :created_by, :on => :create
end
