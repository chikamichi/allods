require "bundler/capistrano"

set :use_sudo, false
set :user, 'jd'

set :scm, :git
set :scm_username, :git
set :deploy_via, :remote_cache

desc "development env"
task :env_dev do
  set :application, "allods"
  set :repository,  "."
  set :branch, 'master'
  set :deploy_to, "/home/jd/allods/web"
  set :application_type, "development"
  set :rails_env, "development"
  set :default_environment, {"RAILS_ENV" => rails_env}
  server "#{user}@#{application}-#{rails_env}", :app, :web, :db, :primary => true

  set :scm, :subversion
  # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

  role :web, "your web-server here"                          # Your HTTP server, Apache/etc
  role :app, "your app-server here"                          # This may be the same as your `Web` server
  role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
  role :db,  "your slave db-server here"
end
