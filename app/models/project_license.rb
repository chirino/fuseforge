class ProjectLicense < ActiveRecord::Base
  acts_as_list

  has_many :projects
  
  def self.other
    self.find_by_name('Other')
  end

  def self.options_for_select
    self.find(:all, :conditions => ['is_active', true], :order => :position).collect { |x| [x.name, x.id] }
  end  
end
