class ProjectStatus < ActiveRecord::Base
  acts_as_list

  has_many :projects
  
  def self.active
    self.find_by_name('Active')
  end

  def self.inactive
    self.find_by_name('Inactive')
  end

  def self.unapproved
    self.find_by_name('Unapproved')
  end
  
  def self.options_for_select
    self.find(:all).collect { |x| [x.name, x.id] }
  end  

  def self.options_for_select_approved
    self.find(:all, :conditions => 'name != "Unapproved"').collect { |x| [x.name, x.id] }
  end  
end
