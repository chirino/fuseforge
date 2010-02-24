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

class ProjectMaturity < ActiveRecord::Base
  acts_as_list

  has_many :projects
  
  def self.proposal
    self.find_by_name('Proposal')
  end

  def self.planning
    self.find_by_name('Planning')
  end

  def self.pre_alpha
    self.find_by_name('Pre-Alpha')
  end
  
  def self.alpha
    self.find_by_name('Alpha')
  end
  
  def self.beta
    self.find_by_name('Beta')
  end
  
  def self.production
    self.find_by_name('Production')
  end
  
  def self.options_for_select
    self.find(:all, :order => :position).collect { |x| [x.name, x.id] }
  end        
end
