class ProjectCategory < ActiveRecord::Base
  acts_as_list

  has_many :projects
  
  validates_presence_of :name

  def count
    projects.count
  end
  
  def self.options_for_select
    self.find(:all, :order => :position).collect { |x| [x.name, x.id] }
  end        
end
