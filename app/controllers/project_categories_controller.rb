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

class ProjectCategoriesController < ApplicationController
  before_filter :get_project_category, :only => [:show, :edit, :update, :destroy]

  allow :index, :show, :new, :create, :edit, :update, :destroy, :user => :is_site_admin?

  def index
    @project_categories = ProjectCategory.find(:all, :order => :position)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_categories }
    end
  end

  def update_positions
    params[:sortable_list].each_index do |i|
      item = ProjectCategory.find(params[:sortable_list][i])
      item.position = i
      item.save
    end
    @project_categories = ProjectCategory.find(:all, :order => 'position')	

    flash.now[:notice] = 'Project categories have been re-ordered.'
    
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace 'flash', :partial => 'shared/flash_msg'
          page.visual_effect(:fade, 'notice', :duration => 5.0)
        end  
      }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_category }
    end
  end

  def new
    @project_category = ProjectCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_category }
    end
  end

  def create
    @project_category = ProjectCategory.new(params[:project_category])

    respond_to do |format|
      if @project_category.save
        flash[:notice] = 'Project Category was successfully created.'
        format.html { redirect_to(@project_category) }
        format.xml  { render :xml => @project_category, :status => :created, :location => @project_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_category.update_attributes(params[:project_category])
        flash[:notice] = 'Project Category was successfully updated.'
        format.html { redirect_to(@project_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_category.destroy

    respond_to do |format|
      format.html { redirect_to(project_categories_url) }
      format.xml  { head :ok }
    end
  end
end

private

def get_project_category
  @project_category = ProjectCategory.find(params[:id])
end