require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|

    FakeWeb.allow_net_connect = false
    FakeWeb.allow_net_connect = %r[^https?://127\.0\.0\.1.+|^https?://localhost/.+]


    config.mock_with :rspec
    config.infer_base_class_for_anonymous_controllers = false

    config.include StepHelpers
    config.include StripeHelper
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
       StripeHelper.setup
    end

    config.before(:each) do
      DatabaseCleaner.start
      @season = FactoryGirl.create(:season)
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end



end

Spork.each_run do
  # This code will be run each time you run your specs.

end



