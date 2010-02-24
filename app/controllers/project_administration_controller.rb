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
class ProjectAdministrationController < ApplicationController
  layout "new_look", :except => [:remove_tag, :add_tag, :auto_complete_for_tag]
  before_filter :get_project, :except => [:auto_complete_for_tag]

  allow :user => :is_project_administrator_for?, :object => :project
  protect_from_forgery :except => [:auto_complete_for_tag]
  
  def index
    respond_to do |format|
      format.html
    end
  end

  def redeploy_internal_components
	  @project.deploy
    flash[:notice] = 'Project components redeployed.'
    render(:action => 'index')
  end

  #
  # Tag Editing...
  #
  def edit_tags
    @project = Project.find(params[:id])
  end
  
  def remove_tag
    @project.tag_list.remove(params[:tag])
    @project.save
  	render( :partial => 'tags_editor' )
  end

  def add_tag
  	@project.tag_list.add(params[:tag])
  	@project.save
  	render( :partial => 'tags_editor' )
  end
  
  def auto_complete_for_tag
    tag = params[:tag] || '' 
    @regex = Regexp.new("(#{Regexp.escape(tag)})", true)
    @tags = Project.tag_counts.select{|x| @regex.match(x.name) }.sort{|x,y| x.name<=>y.name}.first(10)
    render(:partial => 'autocomplete_tags')
  end
  
  private
  
  def get_project
    @project = Project.find(params[:id])
  end


end