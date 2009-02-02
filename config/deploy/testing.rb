set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "#{current_path}/config/deploy/mongrel_cluster_production.yml"
set :rails_env, 'production'
set :user, "rails"
set :port, 30064
set :ssh_options, { :forward_agent => true }
set :use_sudo, true

role :app, "173.45.236.12"
role :web, "173.45.236.12"
role :db,  "173.45.236.12", :primary => true
