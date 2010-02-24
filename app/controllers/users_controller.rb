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

class UsersController < ApplicationController
  layout "new_look"

  before_filter :get_user, :only => [:edit, :update]
  allow :edit, :update, :exec => :can_update?

  def edit_self
    @user = @current_user
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { render :xml => @user }
    end
  end
  
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User Profile Was successfully updated.'
        format.html { redirect_to :controller => 'homepage' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def can_update?
    # Site admin and update any user
    return true if @current_user.is_site_admin?
    # The current user can only update his own profile.
    return @current_user.login == params[:id]
  end
  
end
