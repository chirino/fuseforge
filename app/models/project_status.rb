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

class ProjectStatus < ActiveRecord::Base
  acts_as_list

  has_many :projects
  
  def self.active
    self.find_by_name('Active')
  end

  def self.inactive
    self.find_by_name('Inactive')
  end

  def self.unapproved
    self.find_by_name('Unapproved')
  end
  
  def self.options_for_select
    self.find(:all).collect { |x| [x.name, x.id] }
  end  

  def self.options_for_select_approved
    self.find(:all, :conditions => 'name != "Unapproved"').collect { |x| [x.name, x.id] }
  end  
end
