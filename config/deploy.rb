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
require 'mongrel_cluster/recipes' 

set :stages, %w(default)
set :default_stage, "default"
require 'capistrano/ext/multistage'

set :application, 'fuseforge'

set :repository, 'ssh://git@forge.fusesource.com/fuseforge.git'
set :scm, "git"
set :branch, "master"

set :deploy_via, :copy
set :copy_cache, true
set :copy_exclude, [".git", "materials"]


task :after_update_code, :roles => :app do
  invoke_command "cp -f #{shared_path}/config/crowd.yml #{release_path}/config/crowd.yml" 
  invoke_command "ln -fs /var/forge/attachments #{release_path}/public/attachments" 
end

namespace :deploy do

  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']
  
      template = File.read(File.join(".", "config", "maintenance.rhtml"))
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end

  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        invoke_command "sudo monit -g forge_rails #{t.to_s} all" 
      end
    end
  end

  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    deploy.mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    deploy.mongrel.stop
  end
end

namespace :delayed_job do
  desc "Start delayed_job process" 
  task :start, :roles => :app do
    invoke_command "monit start forge_delayed_job" 
  end

  desc "Stop delayed_job process" 
  task :stop, :roles => :app do
    invoke_command "monit stop forge_delayed_job" 
  end

  desc "Restart delayed_job process" 
  task :restart, :roles => :app do
    invoke_command "monit restart forge_delayed_job"
  end
end

# after "deploy:start", "delayed_job:start" 
# after "deploy:stop", "delayed_job:stop" 
# after "deploy:restart", "delayed_job:restart" 

namespace :db do
  desc "Make symlink for configuration files" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
    run "ln -nfs #{shared_path}/config/secrets.rb #{release_path}/config/secrets.rb" 
  end
end

set :mongrel_config, "/data/fuseforge/shared/config/mongrel_cluster/mongrel_cluster.yml" 
namespace :deploy do
  task :fuseforge_setup do
  	run "mkdir -p #{shared_path}/config"
  end
end

after "deploy:update_code", "db:symlink" 
after "deploy:setup", "deploy:fuseforge_setup"
