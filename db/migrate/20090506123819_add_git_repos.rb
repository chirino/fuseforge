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
class AddGitRepos < ActiveRecord::Migration
  def self.up
    create_table :git_repos do |t|
      t.integer :project_id
      t.boolean :use_internal      
      t.string :external_anonymous_url
      t.string :external_commit_url
      t.string :external_web_url
    end
    
   add_index(:git_repos, :project_id, :unique => true)
    
    #
    # Add a GitRepo to all the projects.
    #
    Project.all.each do |project|
      GitRepo.new(:use_internal => false, :project=>project).save
    end
    
  end

  def self.down
    remove_index :git_repos, :column=>:project_id
    drop_table :git_repos
  end
end
