require 'yaml'
require 'erb'

# Load configuration files in /config/initializers/
#
# Each configuration file can be a plain YAML (*.yml)
# or an ERB template for a YAML document (*.yml.erb)
#
# The root YAML key *must be a symbol*. Allowed values are :
#
#   * :all          for default settings applicable all hosts and environments
#
#   * #{RAILS_ENV}  when you want to override the global settings with
#                   settings specific to the development, cdp, production…
#                   environment
#
#   * `hostname`    when you want to customize your configuration down to
#                   host-specific settings
#
#   * You can also provide a :"`hostname -f`-RAILS_ENV" key for very specific
#     settings
#
#
# @see http://github.com/markbates/configatron/ for more info on configatron
#
if Rails.root.join("config/initializers/config.rb").exist?
  $stdout.puts "Loading config sets"
  Dir["#{Rails.root}/config/set/**/*.{yml,yml.erb}"].sort.each do |f|
    values = YAML.load ERB.new(File.read(f), 0, '<>%-').result

    # Reads a global config
    configatron.configure_from_hash values[:all]

    # Reads a "per env" config
    configatron.configure_from_hash values[Rails.env.to_sym]

    # Reads a "per host" config
    configatron.configure_from_hash values[`hostname -f`.chomp.to_sym]

    # Read a "per host/env" config
    configatron.configure_from_hash values["#{`hostname -f`.chomp}-#{Rails.env}".to_sym]
  end
end
