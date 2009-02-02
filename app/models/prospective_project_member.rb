###############################################################################
# NOTE:  This is not currently being used.
###############################################################################

class ProspectiveProjectMember < ActiveRecord::Base
  attr_accessor :comment
  
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :project_id, :user_id
  validates_associated :project, :user
  
  def accept
    self.project.add_member(user)
    # TODO:  Notify user that they have been accepted as a member.
    self.destroy
  end
  
  def deny
    # TODO:  Notify user that they have been rejected as a member.
    self.destroy
  end
end
