# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================
class ProjectMembersController < ApplicationController
  layout "new_look"
  before_filter :get_project
  before_filter :get_project_user, :only => [:show, :destroy]
  
  allow :create, :destroy, :user => :is_project_administrator_for?, :object => :project
  
  def index
    @users = @group.user_names
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def create
    flash[:error] = nil
    @login = params[:login]
    if @login.blank?
      flash[:error] = 'You must enter a user login!'
    else  
      if user = User.find_or_create_by_crowd_login(@login)
        if @group.contains_user?(user.login)
          flash[:error] = "#{user.full_name} is already in the group!"
        else
          # Force a reresh to get the latest group data..
          user.crowd_refresh
          # User can only join if he has an ICLA on file or is an employee
          if user.is_icla_on_file? || user.is_company_employee?
            @group.add_user(@login)
            flash[:notice] = "#{user.full_name} has joined the group."  
          else
            flash[:error] = "#{user.full_name} does not have an ICLA on file.  Please ask the user to first <a href=\"#{icla_path}\">file an ICLA</a>."
          end
        end
      else
        flash[:error] = "#{@login} is not a valid user login!"
      end
    end  

    respond_to do |format|
      if flash[:error].blank?
        format.html { redirect_to(project_project_members_path(@project)) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @group.remove_user(@user.login)
    respond_to do |format|
      format.html { redirect_to(project_project_members_path(@project)) }
      format.xml  { head :ok }
    end
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id]);
    @group = @project.member_groups.default 
  end
  
  def get_project_user
    @user = User.find(params[:id])
  end  
end
