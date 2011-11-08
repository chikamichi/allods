source 'http://rubygems.org'

gem 'rails',           '~>3.1.1'

#gem 'apotomo',         '~>1.1', :git => 'git://github.com/chikamichi/apotomo.git', :branch => 'builders'
gem 'apotomo',         '~>1.2.1'
gem 'capistrano',      '~>2.5'
gem 'compass',         '~>0.10'
gem 'configatron',     '~>2.7'
gem 'devise',          '~>1.1'
gem 'haml',            '~>3.0'
gem 'kaminari',        '~>0.10'
gem 'markdownizer',    '~>0.3'
gem 'mysql2',          '~>0.2'
gem 'paper_trail',     '~>2.0'
gem 'passenger',       '~>3.0'
gem 'simple_form',     '~>1.3'
gem 'sqlite3-ruby',    '~>1.3',           :require => 'sqlite3'
gem 'state_machine',   '~>0.9'

group :development, :test do
  gem 'yard'
  gem 'rspec-rails',   '~>2.5'
  gem 'factory_girl',  '~>1.3'
  gem 'faker',         '~>0.3'

  # until the v1.0 is released, so I can use acceptance test within RSpec
  #gem 'capybara'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
end

group :production do
  gem 'thin'
end

