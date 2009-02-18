class DownloadRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :url, :project, :user
  validates_associated :project, :user
end
