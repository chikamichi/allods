#require "bundler/capistrano"

set :user, 'jd'
set :use_sudo, false
set :scm, :git
set :scm_username, :git
set :deploy_via, :remote_cache

set :default_environment, {
  'PATH' => '/home/jd/.rvm/gems/ruby-1.9.2-p0/bin:/home/jd/.rvm/gems/ruby-1.9.2-p0@global/bin:/home/jd/.rvm/rubies/ruby-1.9.2-p0/bin:$PATH',
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '/home/jd/.rvm/gems/ruby-1.9.2-p0',
  'GEM_PATH'     => '/home/jd/.rvm/gems/ruby-1.9.2-p0',
  'BUNDLE_PATH'  => '/home/jd/.rvm/gems/ruby-1.9.2-p0'
}
set :application, "hugr.fr"
set :repository,  "git://github.com/chikamichi/allods.git"
set :branch, 'master'
set :deploy_to, "/home/jd/allods/webapp"
set :application_type, "development"
set :rails_env, "corvus"
set :default_environment, {"RAILS_ENV" => rails_env}
server "#{user}@#{application}", :app, :web, :db, :primary => true

# Tasks to perform.

namespace :bundle do
  desc "Install required gems"
  task :install_all do
    run "cd #{current_path} && /home/jd/.rvm/gems/ruby-1.9.2@allods/bin/bundle install --deployment --without development test"
  end
end

# Let's proceed!
after "deploy:update_code", "bundle:install_all"
after "bundle:install_all", "db:create"
after "db:create", "deploy:migrate"
after "deploy:migrate", "deploy:restart"
