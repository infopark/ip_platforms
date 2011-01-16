role :web, 'IPVMW2'
role :app, 'IPVMW2'
role :db,  'IPVMW2', :primary => true

set :deploy_to, '/home/rails/deploy'
set :user, 'rails'
set :group, 'deploy'
set :rails_env, 'production'
