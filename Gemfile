source 'https://rubygems.org'
ruby "2.4.2"

gem 'rails', '5.2'
gem 'bootsnap'
gem 'devise'
gem "simple_form"
gem 'inherited_resources'
gem 'simple_enum', git: 'git://github.com/lwe/simple_enum.git'
gem 'kaminari'
gem 'jquery-rails'
gem 'activerecord-import'

gem 'angularjs-rails'
gem 'activeadmin'
gem 'stripe'
gem 'paypal-express'
gem 'rmagick'
gem 'mime-types'
#gem 'delayed_job_active_record'
gem 'pg'
gem "prawn"#, :git => "git://github.com/prawnpdf/prawn.git"
gem 'prawn-table' #, '~> 0.1.0'
gem 'puma', '~> 3.7'
#gem "select2-rails"
#gem "chosen-koenpunt-rails"
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
gem "chosen-rails"
gem 'bootstrap', '~> 4.1.1'
gem "aws-sdk-s3",  require: false

group :development, :test do
  gem "better_errors"
  gem "hirb"
  gem 'rspec'
  gem "rspec-rails"
  gem 'factory_bot' 
  gem "factory_bot_rails"
  gem 'taps'
  gem "pry-byebug"
  gem "faker"
  gem "populator"
  #gem "fakeweb"  causes failure in carrierwave_direct
  gem "letter_opener"

end

group :test do
  gem 'capybara'
  gem "guard-rspec"
  gem "database_cleaner"
  gem "launchy"
  gem 'simplecov', :require => false
  gem 'selenium-webdriver'
end
