set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "/data/fuseforge/shared/config/mongrel_cluster/mongrel_cluster.yml"
set :rails_env, 'production'
set :user, "rails"
set :port, 22
set :ssh_options, { :forward_agent => true, :keys => %w(/Users/chirino/sandbox/fuse/fuseinfra/images/common/root/.ssh/id_rsa)  }
set :use_sudo, false

host = "forge.e.fusesource.com"
role :app, host
role :web, host
role :db,  host, :primary => true
