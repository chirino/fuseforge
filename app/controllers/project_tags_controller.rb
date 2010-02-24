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

class ProjectTagsController < ApplicationController
  before_filter :get_project
  
  deny :create, :destroy, :exec => :project_unapproved?, :object => :project, :redirect_to => :project
  
  allow :create, :user => :is_project_member_for?, :object => :project, :redirect_to => :project
  allow :index, :destroy, :user => :is_project_administrator_for?, :object => :project, :redirect_to => :project
  
  def create
    @project.tag_list.add(params[:tag])
    
    respond_to do |format|
      flash[:notice] = @project.save ? 'Tag added' : 'Tag not added'
      format.js {
        render :update do |page|
          page.replace 'project_tags', :partial => 'projects/tags'
        end  
      }
      format.html { redirect_to(@project) }
    end
  end

  def destroy
    @project.tag_list.remove(params[:tag])
    respond_to do |format|
      format.html { redirect_to(project_tags_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end  
  
  def project_unapproved?
    not @project.approved?
  end
end
