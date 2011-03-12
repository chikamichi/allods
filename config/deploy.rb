$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.2@allods'
set :rvm_type, :user

set :user, 'jd'
set :use_sudo, false
set :scm, :git
set :scm_username, :git
set :deploy_via, :remote_cache

#set :default_environment, {
  #'PATH' => '/home/jd/.rvm/gems/ruby-1.9.2-p180@allods/bin:/home/jd/.rvm/gems/ruby-1.9.2-p180@global/bin:/home/jd/.rvm/rubies/ruby-1.9.2-p180/bin:$PATH',
  #'RUBY_VERSION' => 'ruby 1.9.2',
  #'GEM_HOME'     => '/home/jd/.rvm/gems/ruby-1.9.2-p180@allods',
  #'GEM_PATH'     => '/home/jd/.rvm/gems/ruby-1.9.2-p180@allods',
  #'BUNDLE_PATH'  => '/home/jd/.rvm/gems/ruby-1.9.2-p180@allods'
#}
set :application, 'hugr.fr'
set :repository,  'git://github.com/chikamichi/allods.git'
set :branch, 'master'
set :deploy_to, '/home/jd/allods/webapp'
set :server_type, 'thin'
set :application_type, 'development'
set :rails_env, 'corvus'
set :default_environment, {'RAILS_ENV' => rails_env}
server "#{user}@#{application}", :app, :web, :db, :primary => true

# Tasks to perform.
namespace :deploy do
  task :start, :depends => [:restart] do
    if server_type == 'thin'
      run "thin start -C #{shared_path}/config/thin.yml"
    end
  end
  task :stop do
    if server_type == 'thin'
      run "thin stop -C #{shared_path}/config/thin.yml"
    end
  end
  task :restart, :roles => :app, :except => { :no_release => true }  do
    if server_type == 'thin'
      run "thin restart -C #{shared_path}/config/thin.yml"
    end
  end
end
namespace :thin do
  desc 'Copy thin config'
  task :copy do
    run "cd #{release_path} && cp config/thin/#{rails_env}.yml #{shared_path}/config/thin.yml"
  end
end
namespace :fs do
  desc 'Create filesystem required folders'
  task :create do
    run "test -d #{shared_path}/log || mkdir #{shared_path}/log"
    run "test -d #{shared_path}/config || mkdir #{shared_path}/config"
    run "test -d #{shared_path}/public || mkdir #{shared_path}/public"
    run "test -d #{shared_path}/public/media || mkdir #{shared_path}/public/media"
    run "cd #{release_path}/public && ln -s #{shared_path}/public/media media"
  end
end
namespace :bundle do
  desc 'Install required gems'
  task :install do
    run "cd #{current_path} && bundle install"
  end
end

# Let's proceed!
after  'deploy:symlink', 'fs:create'
after  'fs:create',      'bundle:install'
before 'deploy:restart', 'thin:copy'

