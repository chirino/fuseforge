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
class NewsItemsController < ApplicationController
	skip_before_filter :login_required, :only => [:index, :show]

  before_filter :get_news_item, :only => [:show, :edit, :update, :destroy]

  allow :new, :create, :edit, :update, :destroy, :user => :is_site_admin?

  def index
    @news_items = NewsItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news_items }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news_item }
    end
  end

  def new
    @news_item = NewsItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news_item }
    end
  end

  def create
    @news_item = NewsItem.new(params[:news_item])

    respond_to do |format|
      if @news_item.save
        flash[:notice] = 'NewsItem was successfully created.'
        format.html { redirect_to(@news_item) }
        format.xml  { render :xml => @news_item, :status => :created, :location => @news_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @news_item.update_attributes(params[:news_item])
        flash[:notice] = 'NewsItem was successfully updated.'
        format.html { redirect_to(@news_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @news_item.destroy

    respond_to do |format|
      format.html { redirect_to(news_items_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_news_item
    @news_item = NewsItem.find(params[:id])
  end
end
