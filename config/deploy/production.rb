role :web, '192.168.193.80'
role :app, '192.168.193.80'
role :db,  '192.168.193.80', :primary => true

set :deploy_to, '/home/rails/deploy'
set :user, 'rails'
set :group, 'deploy'
set :rails_env, 'production'
