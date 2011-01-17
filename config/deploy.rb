# We use multistage deploy from capistrano-ext (gem install capistrano-ext)
set :stages, %w(production)
set :default_stage, 'production'
require 'capistrano/ext/multistage'

# Basic configuration data / defaults
set :scm, 'git'
set :application, 'ip_platforms'
set :repository, "git@192.168.193.80:#{application}.git"
set :branch, 'master'

set :deploy_via, :copy
set :copy_strategy, :export
set :copy_exclude, ['.git']
set :use_sudo, false

ssh_options[:compression]   = false
ssh_options[:encryption]    = 'aes256-cbc'

before 'deploy:setup',        'config:setup'
after  'deploy:update_code',  'deploy:additional_symlinks'
#                              'deploy:compress_assets',
after  'deploy',              'deploy:cleanup'

### Use Phusion Passenger
namespace :deploy do

  task :start do ; end
  task :stop do ; end
  desc 'Restart Rails App using Phusion Passenger'
  task :restart, :roles => :app do
    rails_env = fetch(:rails_env, 'production')
    run "true >#{File.join(shared_path,'log',"#{rails_env}.log")}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc 'Create additional app-specific symlinks for configuration'
  task :additional_symlinks do
    run "ln -nfs #{shared_path}/config/* #{release_path}/config/"
    run "ln -nfs #{shared_path}/cache #{release_path}/tmp"
    run "echo '#{real_revision}' >#{release_path}/REVISION"
  end

  desc 'Remove cached files'
  task :remove_cached_files do
    run "rm -rf #{shared_path}/cache/*"
  end

  task :compress_assets do
    yui_compressor = fetch(:yui_compressor,
              "java -jar script/yuicompressor-2.4.2.jar")
    yuioutput = '/tmp/yuicompress.$$'
    type_mapping = { :javascripts => 'js', :stylesheets => 'css' }
    type_mapping.each do |directory, extension|
      run "cd #{release_path} && find public/#{directory} -name '*.#{extension}' -exec echo 'Compressing #{extension} file {}' \\; -exec #{yui_compressor} --type #{extension} --nomunge -o #{yuioutput} {} \\; -exec cp #{yuioutput} {} \\; -exec rm -f #{yuioutput} \\;"
    end
  end

  namespace :web do
    desc 'Show maintenance page'
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback {
        run "rm #{shared_path}/system/maintenance.html"
      }
      run "ln -s #{current_path}/public/maintenance.html
           #{shared_path}/system/maintenance.html"
    end
  end

end

### Setup / Symlinking of shared files
namespace :config do

  task :setup do
    run("mkdir -p #{shared_path}/cache")
    run("mkdir -p #{shared_path}/downloads")
  end

end

require 'bundler/capistrano'
require 'config/boot'
