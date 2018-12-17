# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'
require 'devise'
require_relative 'support/controller_macros'
require 'pry'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include StepHelpers
  config.extend ControllerMacros, :type => :controller
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!

  #config.include StripeHelper

  config.infer_spec_type_from_file_location!
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    ActiveRecord::Base.observers.disable :all
    FactoryBot.create(:prev_season)
    FactoryBot.create(:season)
    #StripeHelper.setup
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
