set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "/data/fuseforge/shared/config/mongrel_cluster/mongrel_cluster.yml"
set :rails_env, 'production'
set :user, "rails"
set :port, 22
set :ssh_options, { :forward_agent => true, :keys => %w(/Users/chirino/sandbox/fuse/fuse-infra/images/common/root/.ssh/id_rsa)  }
set :use_sudo, false

role :app, "dev-forge.e.fusesourcedev.com"
role :web, "dev-forge.e.fusesourcedev.com"
role :db,  "dev-forge.e.fusesourcedev.com", :primary => true
