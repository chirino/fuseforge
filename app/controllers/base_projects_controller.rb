class BaseProjectsController < ApplicationController
  private

  def get_project
    @project = Project.find(params[:project_id])
  end

  def project_private_and_user_not_member?
    @project.is_private? and not current_user.is_project_member_for?(@project)
  end  

  def user_is_administrator_for_project_and_company_employee?
    current_user.is_project_administrator_for?(@project) and current_user.is_company_employee?
  end  
end