namespace :db do
  MODELS = [
    # LootStatus factory triggers creation of users, characters and loot machines
    # through associations.

    #:user,
    #:character,
    #:loot_machine,
    :loot_status
  ]

  desc "initialize"
  task :init => [:environment] do
    require 'factory_girl/syntax/blueprint'
    require 'faker'
    Dir.glob("spec/factories/*.rb") do |file_require|
      load file_require
    end

    # Don't send emails.
    ActionMailer::Base.delivery_method = :test

    def print_more
      print '.'
      STDOUT.flush
    end

    def nb
      (ENV['NB'] || 1).to_i
    end

    def generate model, attributes = {}
      10.times do
        Factory.create model.to_sym, attributes
        print_more
      end
      puts ""
    end
  end

  desc "perform all populate tasks"
  task :populate => [:init] do
    Rake::Task['db:populate:default'].invoke
  end

  namespace :populate do
    desc 'default: perform all populate tasks'
    task :default => MODELS

    MODELS.each do |model|
      class_eval do
        desc "Create 10 #{model.to_s.camelize} records"
        task model => :init do
          print "Creating 10 #{model.to_s.camelize} records "
          generate model
        end
      end
    end
  end
end
