class DeploymentStatus < ActiveRecord::Base
  belongs_to :project
  
  attr_protected :next_deployment
  attr_protected :last_deployment

  belongs_to :job, :class_name => "Delayed::Job"



end