require 'mongrel_cluster/recipes' 

set :stages, %w(default)
set :default_stage, "default"
require 'capistrano/ext/multistage'

set :application, 'fuseforge'
set :deploy_via, :copy
set :copy_strategy, :export
set :repository, 'http://fusesource.com/forge/svn/fuseforge/rails/trunk'

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
        #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method
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
  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
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
