require 'bundler/capistrano'

set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "awesome"

set :scm, :git
set :repository, "git@github.com:engineyard/eycap-vagrant.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:port] = 2222
ssh_options[:keys] = "~/.vagrant.d/insecure_private_key"

set :user, "vagrant"
set :group, "vagrant"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false

set :deploy_via, :copy
set :copy_strategy, :export

namespace :deploy do 
  task :start do ; end
  task :stop do ; end
  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "Copy the database.yml file into the latest release"
  task :copy_in_database_yml do
    run "cp #{shared_path}/config/database.yml #{latest_release}/config/"
  end  
end

before "deploy:assets:precompile", "deploy:copy_in_database_yml"

set :cleanup_targets, %w(log public/system tmp) 
set :release_directories, %w(log tmp)

set :release_symlinks do
  {
"config/settings/#{stage}.yml" => 'config/settings.yml',
"config/database/#{stage}.yml" => 'config/memcached.yml', 
  }
end

set :shared_symlinks, {
'log' => 'log',
'pids' => 'tmp/pids', 
'sockets' => 'tmp/sockets', 
'system' => 'public/system'
}

namespace :deploy do
  desc "Create symlinks to stage-specific configuration files and shared resources"
  task :symlink, :roles => :app, :except => { :no_release => true } do
    symlink_command = cleanup_targets.map { |target| "rm -fr #{current_path}/#{target}" }
    symlink_command += release_directories.map { |directory| "mkdir -p #{directory}" }
    symlink_command += release_symlinks.map { |from, to| "rm -fr #{current_path}/#{to} && ln -sf #{current_path}/#{from} #{current_path}/#{to}" }
    symlink_command += shared_symlinks.map  { |from, to| "rm -fr #{current_path}/#{to} && ln -sf #{shared_path}/#{from} #{current_path}/#{to}" }
    run "cd #{current_path} && #{symlink_command.join(' && ')}"
  end
end

after "deploy", "deploy:cleanup"