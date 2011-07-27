# this file is for the capistrano staging settings. It will override the normal deploy file, when staging is selected.
# from http://cjohansen.no/en/rails/multi_staging_environment_for_rails_using_capistrano_and_mod_rails

set :deploy_to, "/home/#{user}/rails/#{application}"
set :rails_env, "production"

# Deploy to production site only from stable branch
set :branch, "master"