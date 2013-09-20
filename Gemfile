source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'devise'
gem "simple_form"
gem 'inherited_resources'
gem 'simple_enum'
gem 'kaminari'
gem 'jquery-rails', "2.3.0"
gem 'activerecord-import',  "0.3.1"

gem 'activeadmin', :git=> 'git://github.com/gregbell/active_admin.git', :ref => 'c2ca07ee98883e14fc11135af534af7bf7be52b6'
gem 'stripe'
gem 'paypal-express'
gem 'rmagick'
gem 'carrierwave'
gem 'carrierwave_direct'
gem 'fog'
gem 'delayed_job_active_record'
gem 'pg'
gem 'chosen-rails'

group :production do
  gem 'thin'
  gem 'aws-sdk'
end

group :development, :test do
  gem "better_errors"
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
  gem "guard-zeus"

end

group :test do
  gem 'capybara'
  gem 'factory_girl' 
  gem "factory_girl_rails"
  gem "guard-rspec"
  gem "database_cleaner"
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem "launchy"
  gem 'simplecov', :require => false
  gem 'selenium-webdriver'
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





