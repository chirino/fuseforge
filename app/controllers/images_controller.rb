class ImagesController < ApplicationController
	skip_before_filter :login_required

  before_filter :get_project

  deny :show, :exec => :project_private_and_user_not_member?

  def show
    send_file(@project.image.path(params[:id]))
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end    
  
  def project_private_and_user_not_member?
    @project.is_private? and not current_user.is_project_member_for?(@project)
  end  
end  