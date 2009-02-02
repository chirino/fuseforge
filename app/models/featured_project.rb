class FeaturedProject < ActiveRecord::Base
  acts_as_list
  
  belongs_to :project
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  named_scope :all_ordered_by_position, :order => :position

  validates_presence_of :project
  validates_associated :project, :updated_by
  validates_associated :created_by, :on => :create

  def validate
    self.errors.add(:project, 'cannot be unapproved.') unless self.project.blank? or self.project.approved?
    self.errors.add(:project, 'cannot be private.') unless self.project.blank? or not self.project.is_private?
  end
  
  def self.projects
    self.all_ordered_by_position.collect { |fp| fp.project }
  end  
end
