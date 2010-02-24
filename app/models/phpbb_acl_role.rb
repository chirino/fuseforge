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
  class PhpbbAclRole < ActiveRecord::Base
    establish_connection "phpbb"
    set_table_name "phpbb_acl_roles"
    set_primary_key "role_id"
  
    FORUM_NOACCESS = 16
    FORUM_READONLY = 17
    FORUM_BOT      = 19
    FORUM_STANDARD = 15
    FORUM_FULL     = 14
    FORUM_POLLS    = 21
    MOD_FULL       = 10
  end
end