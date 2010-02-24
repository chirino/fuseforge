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
class FeaturedProjectsController < ApplicationController
  allow :user => :is_site_admin?
  
  before_filter :get_featured_projects, :only => [:index]

  def index
    @featured_project = FeaturedProject.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @featured_projects }
    end
  end

  def new
    @featured_project = FeaturedProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @featured_project }
    end
  end

  def create
    @featured_project = FeaturedProject.new(:project_id => params[:id].gsub('project_', ''))

    respond_to do |format|
      if @featured_project.save
        flash[:notice] = 'Project is now being featured.'
        format.js {
          get_featured_projects
          render :update do |page|
            page.remove params[:id]
            page.replace 'flash', :partial => 'shared/flash_msg'
            page.replace 'featured_projects', :partial => 'featured_projects'
            page.visual_effect :fade, 'flash', :duration => 5.0
          end  
        }
      else
        flash[:notice] = 'An error occured while trying to feature the project.'
        format.js {
          render :update do |page|
            page.replace 'flash', :partial => 'shared/flash_msg'
            page.visual_effect :fade, 'flash', :duration => 5.0
          end  
        }
      end
    end
  end
  
  def destroy
    @featured_project = FeaturedProject.find(params[:id].gsub('featured_project_', ''))
    @featured_project.destroy

    flash[:notice] = 'Project is no longer being featured.'

    respond_to do |format|
      format.js {
        get_featured_projects
        render :update do |page|
          page.replace 'flash', :partial => 'shared/flash_msg'
          page.replace 'featured_projects', :partial => 'featured_projects'
          page.replace 'unfeatured_projects', :partial => 'unfeatured_projects'
          page.visual_effect :fade, 'flash', :duration => 5.0
        end  
      }
    end
  end
  
  private
  
  def get_featured_projects
    @featured_projects = FeaturedProject.all_ordered_by_position
  end
end
