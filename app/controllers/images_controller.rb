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