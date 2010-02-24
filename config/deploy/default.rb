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
set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "/data/fuseforge/shared/config/mongrel_cluster/mongrel_cluster.yml"
set :rails_env, 'production'
set :user, "rails"
set :port, 22
set :ssh_options, { :forward_agent => true, :keys => %w(/Users/chirino/sandbox/fuse/fuseinfra/images/common/root/.ssh/id_rsa)  }
set :use_sudo, false

host = "forge.e.fusesourcedev.com"
role :app, host
role :web, host
role :db,  host, :primary => true
