class Download < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :url, :description, :project
  validates_associated :project
end
