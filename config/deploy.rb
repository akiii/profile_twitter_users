require 'capistrano_colors'

#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#require 'rvm/capistrano'
#set :rvm_ruby_string, '1.9.3p194'
#set :rvm_type, :user

set :application, "profile_twitter_users"
set :repository,  "https://github.com/akiii/profile_twitter_users.git"
set :branch, "master"
set :scm, :git

set :rails_env, "production"
set :user, "profile_twitter_users"
set :use_sudo, false
set :deploy_to, "/home/profile_twitter_users/apps/#{application}"
set :normalize_asset_timestamps, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "akiiisuke.com"                          # Your HTTP server, Apache/etc
role :app, "akiiisuke.com"                          # This may be the same as your `Web` server
role :db,  "akiiisuke.com", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require 'capistrano-unicorn'
