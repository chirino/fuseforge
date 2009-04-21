set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "#{current_path}/config/deploy/mongrel_cluster_default.yml"
set :rails_env, 'production'
set :user, "rails"
set :port, 22
set :ssh_options, { :forward_agent => true, :keys => %w(/Users/chirino/sandbox/fuse/fuse-infra/images/common/root/.ssh/id_rsa)  }
set :use_sudo, false

role :app, "localhost"
role :web, "localhost"
role :db,  "localhost", :primary => true
