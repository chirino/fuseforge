class ProjectMaturity < ActiveRecord::Base
  acts_as_list

  has_many :projects
  
  def self.proposal
    self.find_by_name('Proposal')
  end

  def self.planning
    self.find_by_name('Planning')
  end

  def self.pre_alpha
    self.find_by_name('Pre-Alpha')
  end
  
  def self.alpha
    self.find_by_name('Alpha')
  end
  
  def self.beta
    self.find_by_name('Beta')
  end
  
  def self.production
    self.find_by_name('Production')
  end
  
  def self.options_for_select
    self.find(:all, :order => :position).collect { |x| [x.name, x.id] }
  end        
end
