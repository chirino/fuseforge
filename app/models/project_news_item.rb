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

class ProjectNewsItem < ActiveRecord::Base
  RECENT_LIMIT = 5

  belongs_to :project
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  named_scope :recent, :order => 'created_at desc', :limit => RECENT_LIMIT  

  named_scope :recent_excluding_private, :conditions => ['projects.is_private = ?', false ], :include => :project, 
                       :order => 'project_news_items.created_at desc', :limit => 5  
  
  validates_presence_of :title, :project
  validates_associated :project, :updated_by
  validates_associated :created_by, :on => :create
  
  def homepage_title
    "#{project.name}: #{title}"
  end
end
