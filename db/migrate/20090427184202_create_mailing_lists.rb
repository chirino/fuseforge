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
class CreateMailingLists < ActiveRecord::Migration
  def self.up
    create_table :mailing_lists do |t|
      t.integer :project_id
      t.string :name
      
      t.boolean :use_internal
      t.string :external_post_address
      t.string :external_subscribe_address
      t.string :external_unsubscribe_address
      
      t.string :internal_replyto      
    end
    
   add_index(:mailing_lists, [:project_id, :name], :unique => true)
    
    #
    # Add the default mailing lists to all the projects
    #
    Project.all.each do |project|
      project.send :add_default_mailing_lists
    end
    
  end

  def self.down
    remove_index :mailing_lists, :column => [:project_id, :name]
    drop_table :mailing_lists
  end
end