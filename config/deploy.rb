# set :application, "feedbackd"
# set :user, "p1707r99" #defines the user variable for the rest of this document...
# set :repository,  "#{user}@#{domain}:/home/#{user}/git/#{application}" #where's the repo
# 
# set :scm, :git
# # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
# 
# set :scm_username, user
# set :runner, user
# set :use_sudo, false
# set :branch, "master" #what branch to use
# set :deploy_via, :checkout
# set :git_shallow_clone, 1
# set :deploy_to, "/home/#{user}/apps/#{application}"
# default_run_options[:pty] = true #ensure that normal password prompts are run through


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

# settings for staging / prod env's
set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, 'foolio' #app name
set :user, 'feedback' #hosting rails user name
set :domain, 'http://74.63.4.138/~feedback/' #server name here. IP address or domain name 
set :mongrel_port, '17750' #port you get assigned through cpanel
set :server_hostname, '74.63.4.138' #ip address or server name

#set :git_account, 'put_your_git_account_name_here' #not needed because I'm setting it explicitly down below

set :scm_passphrase,  Proc.new { Capistrano::CLI.password_prompt('Git Password: ') }

role :web, server_hostname
role :app, server_hostname
role :db, server_hostname, :primary => true

default_run_options[:pty] = true
#set :repository,  "git@github.com:#{git_account}/#{application}.git"
set :repository,  "git@jamis82.beanstalkapp.com:/feedbackd.git" #git clone url received from beanstalked
set :scm, "git"
set :user, user

ssh_options[:forward_agent] = true
set :branch, "_master_staging"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :deploy_to, "/home/#{user}/rails/#{application}"




# run these after the deploy has happened
after 'deploy:symlink', 'deploy:finishing_touches'
# copies the DB config file AND env file, so you don't store it in GIT? not sure about this...
namespace :deploy do
	
	task :finishing_touches, :roles => :app do
		# Avoid keeping the database.yml configuration in git.
    	db_config = "#{deploy_to}/copy_to/conf/database.yml"
	  	run "cp #{db_config} #{release_path}/config/database.yml"
	
		ht_access = "#{deploy_to}/copy_to/public/.htaccess"
		run "cp #{ht_access} #{release_path}/public/.htaccess"
  	end

	desc "Restarting mod_rails with restart.txt"
  		task :restart, :roles => :app, :except => { :no_release => true } do
   		run "touch #{current_path}/tmp/restart.txt"
  	end
end


# task :copy_database_yml, :roles => :app do
# 	db_config = "#{deploy_to}/copy_to/conf/database.yml"
# 	#run "cp #{db_config} #{release_path}/config/database.yml"
# end

# #run these after the deploy has happened
# after 'deploy:symlink', 'deploy:restart'
# namespace :deploy do
#   desc "Restarting mod_rails with restart.txt"
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "touch #{current_path}/tmp/restart.txt"
#   end
# 
#   [:start, :stop].each do |t|
#     desc "#{t} task is a no-op with mod_rails"
#     task t, :roles => :app do ; end
#   end
# end


# # Avoid keeping the database.yml configuration in git.
# task :copy_database_yml, :roles => :app do
#   db_config = "/home/#{user}/rails/#{application}/common/conf/database.yml"
#   run "cp #{db_config} #{release_path}/config/database.yml"
# end
# 
# # Avoid keeping pubic/.htaccess in GIT (because they change for the envs)
# task :copy_htaccess, :roles => :app do
#   db_config = "/home/#{user}/rails/#{application}/common/public/.htaccess"
#   run "cp #{db_config} #{release_path}/public/.htaccess"
# end





