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

if ActiveRecord::Base.configurations["phpbb"]
  class PhpbbTopic < ActiveRecord::Base
    establish_connection "phpbb"
    set_table_name "phpbb_topics"
    set_primary_key "topic_id"
  
    belongs_to :phpbb_forum, :class_name => "PhpbbForum", :foreign_key => "forum_id"

    has_many :phpbb_posts, :class_name => "PhpbbPost", :foreign_key => "post_id"
  end
end