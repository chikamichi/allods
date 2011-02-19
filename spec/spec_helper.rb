# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rack/test'
require 'factory_girl/syntax/blueprint'
require 'faker'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}

# Ensure a collection is made of objects of a certain type.
#
# @example
#
#   response.should be_an Array of User
#
RSpec::Matchers.define :of do |expected|
  match do |collection|
    collection.all? do |item|
      item.is_a? expected
    end
  end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
end
