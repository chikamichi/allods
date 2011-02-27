$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "bundler/capistrano"

# Generic setup.
set :user, 'jd'
set :use_sudo, false
set :rvm_type, :user
set :scm, :git
set :scm_username, :git
set :deploy_via, :remote_cache
set :application, "hugr.fr"
set :repository,  "git://github.com/chikamichi/allods.git"
set :branch, 'master'

# Specific deploy environments setups.
desc "development env"
task :env_dev do
  set :rvm_ruby_string, 'ruby-1.9.2@allods-dev'
  set :deploy_to, "/home/jd/allods/webapp.dev"
  set :application_type, "development"
  set :rails_env, "development"
  set :default_environment, {"RAILS_ENV" => rails_env}
  server "#{user}@#{application}", :app, :web, :db, :primary => true
end

# Tasks to perform.
namespace :generic do
  desc "Export $PATH"
  task :export_path do
    run "export PATH=/home/#{user}/.rvm/:$PATH"
  end
end

namespace :bundle do
  desc "Install required gems"
  task :install do
    run "cd #{current_path} && bundle install --deployment --without production"
end

  end
end

# Let's proceed!
after "deploy:update_code", "generic:export_path"
after "generic:export_path", "bundle:install"
after "bundle:install", "db:create"
after "db:create", "deploy:migrate"
after "deploy:migrate", "deploy:restart"
