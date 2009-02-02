set :deploy_to, "/data/fuseforge"
set :mongrel_conf, "#{current_path}/config/deploy/mongrel_cluster_production.yml"
set :rails_env, 'production'

role :app, "www.ionadev.com"
role :web, "www.ionadev.com"
role :db,  "www.ionadev.com", :primary => true
