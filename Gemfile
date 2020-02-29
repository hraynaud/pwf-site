source 'https://rubygems.org'
ruby "2.5.0"

gem 'rails', '5.2.2.1'
gem 'bootsnap'
gem 'devise', ">= 4.6.0"
gem "simple_form"
gem 'simple_enum', git: 'git://github.com/lwe/simple_enum.git'
gem 'kaminari'
gem 'activerecord-import'
gem 'font-awesome-sass', '~> 5.2.0'
gem 'pg'
gem 'puma', '~> 4.3'
gem 'activeadmin'
gem 'activeadmin_blaze_theme'
gem 'inherited_resources'
gem 'stripe'
gem "aws-sdk-s3",  require: false
gem "image_processing", "~> 1.2"
gem "prawn"#, :git => "git://github.com/prawnpdf/prawn.git"
gem 'prawn-table' #, '~> 0.1.0'
gem "bootstrap", ">= 4.3.1"
gem 'jquery-rails'
gem "chosen-rails"
gem 'rails-observers'
gem 'combine_pdf'
gem 'figaro'
gem 'exception_handler'
gem "chartkick"
gem 'activeadmin_medium_editor', git: "git://github.com/hraynaud/activeadmin_medium_editor.git"
gem 'sidekiq'

group :development, :test do
  gem "better_errors"
  gem "hirb"
  gem 'rspec'
  gem "rspec-rails"
  gem 'factory_bot' 
  gem "factory_bot_rails"
  gem "faker"
  gem "populator"
  gem "pry"
  gem "pry-nav"
  gem "fakeweb", git: "https://github.com/chrisk/fakeweb.git"
end

group :development, :test, :production_local do
  gem "letter_opener"
end

group :test do
  gem 'capybara'
  gem "guard-rspec"
  gem "rspec-activemodel-mocks"
  gem "database_cleaner"
  gem "launchy"
  gem 'simplecov', :require => false
  gem 'selenium-webdriver'
end
