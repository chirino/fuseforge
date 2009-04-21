set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "/data/fuseforge/shared/config/mongrel_cluster/mongrel_cluster.yml"
set :rails_env, 'development'
set :user, "rails"
set :port, 22
set :ssh_options, { :forward_agent => true }
set :use_sudo, false

role :app, "localhost"
role :web, "localhost"
role :db,  "localhost", :primary => true
