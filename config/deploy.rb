require 'bundler/capistrano'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :application, "weekreport"
set :repository,  "git://github.com/sizzlelab/weekreport.git"
set :user, "kassi"
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
ssh_options[:forward_agent] = true
set :use_sudo, false

set :deploy_via, :remote_cache

set :deploy_to, "/opt/weekreport"

set :host, "aws.kassi.eu"
set :server_name, "aws"
set :branch, ENV['BRANCH'] || "master"

role :app, host
role :web, host
role :db, host, :primary => true


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :symlinks_to_shared_path do
    run "ln -nfs #{shared_path}/system/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/system/session_secret #{release_path}/config/session_secret"
    run "ln -nfs #{shared_path}/system/config.yml #{release_path}/config/config.yml"
  end
end

after "deploy:update_code" do
  deploy.symlinks_to_shared_path
end

