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
class AddDeploymentStatus < ActiveRecord::Migration
  def self.up
    add_column :wikis, :last_permissions, :text

    create_table :deployment_statuses do |t|
      t.integer  :project_id
      t.integer  :job_id
      t.integer  :next, :integer, :default => 0
      t.integer  :last, :integer, :default => 0
    end

    add_index(:deployment_statuses, :project_id, :unique => true)
    
    Project.all.each do |project|
      DeploymentStatus.new(:project=>project).save
      project.wiki.last_permissions = project.wiki.all_permissions
      project.wiki.save
    end
        
  end

  def self.down
    remove_column :wikis, :last_permissions
    drop_table :deployment_statuses
  end
end
