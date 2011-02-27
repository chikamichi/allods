$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "bundler/capistrano"

# Generic setup.
set :user, 'jd'
set :use_sudo, false
set :rvm_type, :user
set :scm, :git
set :scm_username, :git
set :deploy_via, :remote_cache

# Specific deploy environments setups.
desc "development env"
task :env_dev do
  set :application, "hugr.fr"
  set :repository,  "git://github.com/chikamichi/allods.git"
  set :branch, 'master'
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
    run "export GEM_PATH=/home/#{user}/.rvm/gems/#{rvm_ruby_string}:/home/jd/.rvm/gems/ruby-1.9.2-p0@global"
    run "export GEM_HOME=/home/#{user}/.rvm/gems/ruby-1.9.2-p0"
  end
end

namespace :bundle do
  desc "Install required gems"
  task :install_all do
    run "cd #{current_path} && bundle install --deployment --without production"
  end
end

# Let's proceed!
after "deploy:update_code", "generic:export_path"
after "generic:export_path", "bundle:install_all"
after "bundle:install_all", "db:create"
after "db:create", "deploy:migrate"
after "deploy:migrate", "deploy:restart"
