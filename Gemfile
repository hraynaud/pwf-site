source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'devise'
gem "simple_form"
gem 'inherited_resources'
gem 'simple_enum'
gem 'kaminari'
gem 'jquery-rails'

gem 'mysql2'
gem 'activerecord-import'

gem 'activeadmin', :git=> 'git://github.com/gregbell/active_admin.git', :ref => 'c2ca07ee98883e14fc11135af534af7bf7be52b6'
gem 'stripe'
gem 'paypal-express'
group :production do
  gem 'thin'
  gem 'aws-sdk'
  gem 'pg'
end

group :development, :test do
  gem "hirb"
  gem 'rb-fsevent'
  gem 'rspec'
  gem "rspec-rails"
  gem 'taps'
  gem "pry"
  gem "pry-rails"
  gem "pry-nav"
  gem "faker"
  gem "populator"
  gem "fakeweb"
end

group :test do
  gem 'capybara'
  gem 'factory_girl', '~> 3.0'
  gem "factory_girl_rails", '~> 3.0'
  gem "guard-rspec"
  gem "spork", ">0.9.0.rc"
  gem "guard-spork"
  gem "database_cleaner"
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem "launchy"
  gem 'simplecov', :require => false
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do

  gem 'sass-rails',   "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'bootstrap-sass'
  gem 'twitter-bootstrap-rails'
  gem 'uglifier', "~> 1.0.3"
end





