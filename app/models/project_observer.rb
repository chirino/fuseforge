class ProjectObserver < ActiveRecord::Observer
  cattr_accessor :current_user

  def before_create(project)
    project.created_by = @@current_user
  end

  def before_save(project)
    project.updated_by = @@current_user
  end
  
end
